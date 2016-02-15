<?php
// AddRating
//
// This script will add IMDB ratings to the spot title, like: "Movietitle (2014) release info [6.5]
// It will also adjust the spot rating, based on the IMDB rating
// The script assumes the spot title syntax is like: "Movie title (year) release info"
//
// Original code from MR_Blobby http://gathering.tweakers.net/forum/list_message/43647658#43647658
// Edited by Rowdy - http://rowdy.nl


// ====================================================================================================================
// PARAMETERS, ESIT FOR YOUR INSTALLATION
// ====================================================================================================================


// Location of Spotweb db settings file
$dbsettingsfile = "/Users/Plex/Spotweb/dbsettings.inc.php";

// Should we send some output? Ie for logging use: php addrating.php >> /var/log/spotweb
$quiet = false;
$timestamp = false; // Timestamp in logging

// Age of spots to query for (in seconds):
$age = 86400; // 1 day

// Minimum string similarity between movie title from spot and movie title from IMDB (http://php.net/manual/en/function.similar-text.php)
// Percentage (100 is exact match):
$min_similar_text = 75;

// set the default timezone to use. Available since PHP 5.1
date_default_timezone_set('CET');



// ====================================================================================================================
// DO NOT EDIT BELOW
// ====================================================================================================================

// Show that we are starting
doLog("Started rating of movies");
$found = 0;
$rated = 0;

// Create MySQL connection (fill in correct values):
require($dbsettingsfile);
$con = mysqli_connect($dbsettings['host'], $dbsettings['user'], $dbsettings['pass'], $dbsettings['dbname']);

// Initiate the IMDB class:
require("./imdb.php");
$imdb = new Imdb();

// Check connection:
if (mysqli_connect_errno($con))
    doLog("Failed to connect to MySQL: " . mysqli_connect_error());
else
{
    // Connection is ok
    $timestamp = time() - $age;
    
    // This query will return all x264 movies (category 0 is "images", subcatz z0 is "movies" and subcata a09 is "x264"):
    $query = "SELECT * FROM spots WHERE category=0 AND subcatz='z0|' AND subcata='a9|' AND stamp>" . $timestamp . " ORDER BY stamp";
    $result = mysqli_query($con,$query);
    
    // Process all results:
    while ($row = mysqli_fetch_array($result))
    {
        $found++;
        $title = str_replace("&period;", ".", $row['title']);
        doLog("Spot: ".$title."(".$row['messageid'].")");

        // Regular expression to try to get a "clean" movietitle from the spot title (all text until "year"):
        if ((preg_match('/(.+)[ \(\.]((19|20)\d{2})/', $title, $matches)) == 1)
        {
            $title_from_spot = trim($matches[1]);
            $year = trim($matches[2]);
            $title_from_spot = str_replace(".", " ", $title_from_spot);
            doLog("Using as title \"".$title_from_spot."\", year: ".$year);
            
            // Search movie info from IMDB:
            $movieArray = $imdb->getMovieInfo($title_from_spot . " (" . $year . ")", False);
            if (isset($movieArray['title_id']) and !empty($movieArray['title_id'])) 
            { 
                // Succesfully found
                $imdb_year = trim($movieArray['year']);
                $imdb_title = $movieArray['title'];
                $imdb_url = $movieArray['imdb_url'];
                
                // Calculate the similarity between the movietitle from the spot and the movietitle found in IMDB:
                $percent = compareTitles(strtolower($title_from_spot), strtolower($imdb_title));
                doLog("Found: ".$imdb_title." (".$imdb_year."), ".round($percent, 2)."% match");
                
                // Assume the correct movie is found in IMDB when the similarity is higher then defined and the year from IMDB is the same as from the spot:
                if (($imdb_year == $year) and ($percent >= $min_similar_text))
                {
                    $imdb_rating = $movieArray['rating'];
                    
                    if (!empty($imdb_rating))
                    {
                        // Rating found
                        if ((preg_match('/(.+)( \[\d\.\d\])/', $title, $matches)) == 1)
                            // If the rating had already been added to the title, strip it
                            $title = $matches[1];
                            
                        // Add the rating to the spot title:
                        $newtitle = str_replace(".", "&period;", $title)." [".$imdb_rating."]";
                        $updateresult = mysqli_query($con, "UPDATE spots SET title = '".$newtitle."' WHERE id = ".$row['id']);
                        $spotrating = 0;
                        
                        // Calculate the spotrating based on imdb rating (only valid spotrating when imdb rating is at least 6.0):
                        if ($imdb_rating >= 6.0) {$spotrating = 1;}
                        if ($imdb_rating >= 6.2) {$spotrating = 2;}
                        if ($imdb_rating >= 6.4) {$spotrating = 3;}
                        if ($imdb_rating >= 6.6) {$spotrating = 4;}
                        if ($imdb_rating >= 6.8) {$spotrating = 5;}
                        if ($imdb_rating >= 7.0) {$spotrating = 6;}
                        if ($imdb_rating >= 7.2) {$spotrating = 7;}
                        if ($imdb_rating >= 7.4) {$spotrating = 9;}
                        if ($imdb_rating >= 7.6) {$spotrating = 10;}
                        
                        setSpotRating($con, $spotrating, $row['id']);
                        doLog("Rating of ".$imdb_rating." found. Spotrating ".$spotrating." set.");
                        $rated++;
                    }
                    else
                    {
                        // Clear spotrating if no rating found in IMDB
                        setSpotRating($con, 0, $row['id']);
                        doLog("No rating found found");
                    }
                }
                else
                {
                    // Clear spotrating if the correct movie is not found in IMDB
                    setSpotRating($con, 0, $row['id']);
                    doLog("No matching movie found");
                }
            }
            else
            {
                // Clear spotrating if no movie is found in IMDB
                setSpotRating($con, 0, $row['id']);
                doLog("No movie found");
            }
        }
        else
        {
            // Clear spotrating if the movie title could not be extracted from the spot title
            setSpotRating($con, 0, $row['id']);
            doLog("No title found");
        }
    }

    // Close MySQL connection:
    mysqli_close($con);
    
    doLog($found." movies processed, of wich ".$rated." rated");
}


// ====================================================================================================================
// Functions
// ====================================================================================================================

function doLog($message)
{
    global $quiet;
    global $timestamp
    
    if(!$quiet)
    {
        if($timestamp)
            echo date(DATE_ATOM)." ";
        echo $message.PHP_EOL;
    }
}

//Strip titles and compare
function compareTitles($string1, $string2)
{
    //Replace HTML characters
    $string1 = html_entity_decode($string1, ENT_QUOTES);
    $string2 = html_entity_decode($string2, ENT_QUOTES);

    //Lowercase
    $string1 = strtolower($string1);
    $string2 = strtolower($string2);

    //Remove unnecessary characters
    $string1 = preg_replace('~[^A-Za-z0-9]~', "", $string1);
    $string2 = preg_replace('~[^A-Za-z0-9]~', "", $string2);

    //Do we have a match?
    similar_text($string1, $string2, $percentage);

    return $percentage;
}

function setSpotRating($con, $rating, $id)
{
    $updateresult = mysqli_query($con, "UPDATE spots SET spotrating = '".$rating."' WHERE id = ".$id);
}

?>
