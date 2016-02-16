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
//require("./imdb.php");
//$imdb = new Imdb();

// Check connection:
if (mysqli_connect_errno($con))
    doLog("Failed to connect to MySQL: " . mysqli_connect_error());
else
{
    // Connection is ok
    $timestamp = time() - $age;
    
    // This query will return all x264 movies (category 0 is "images", subcatz z0 is "movies" and subcata a09 is "x264"):
    $query = "SELECT * FROM spots WHERE spotterid = 'C7w1uw' AND subcatz = 'z1|' AND stamp>" . $timestamp . " ORDER BY stamp";
    $result = mysqli_query($con,$query);
    
    // Process all results:
    while ($row = mysqli_fetch_array($result))
    {
        $found++;
        $title = str_replace("&period;", ".", $row['title']);
        doLog("Spot: ".$title.", Row: ".$row['messageid']);

$seasonarray = get_season_number($title);
doLog("Possible season number: " . $seasonarray['res']);
$episodearray = get_episode_number($title);
doLog("Possible episode number: " . $episodearray['res']);

$cleanshowname = $title;
if ($seasonarray) {
        $cleanshowname = trim(str_replace($seasonarray['del'],'',$cleanshowname));
}
$cleanshowname = trim(str_replace($episodearray['del'],'',$cleanshowname));
doLog("Clean Show Name: " . $cleanshowname);


        // Regular expression to try to get a "clean" movietitle from the spot title (all text until "year"):
        if ((preg_match('/(.+)[ \(\.]((19|20)\d{2})/', $title, $matches)) == 1)
        {
            $title_from_spot = trim($matches[1]);
            $year = trim($matches[2]);
            $title_from_spot = str_replace(".", " ", $title_from_spot);
            doLog("Using as title \"".$title_from_spot."\", year: ".$year);
            
            // setSpotTitle($con, $title_from_spot, $row['id']);
            // doLog("No matching movie found");
            
            $rated++;
        }
        else
        {
            // Clear spotrating if the movie title could not be extracted from the spot title
            //setSpotRating($con, 0, $row['id']);
            //doLog("No title found");
        }
    }

    // Close MySQL connection:
    mysqli_close($con);
    
    doLog($found." spots processed, of wich ".$rated." rated");
}


// ====================================================================================================================
// Functions
// ====================================================================================================================

function doLog($message)
{
    global $quiet;
    global $timestamp;
    
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

function setSpotTitle($con, $title, $id)
{
    //$updateresult = mysqli_query($con, "UPDATE spots SET spotrating = '".$rating."' WHERE id = ".$id);
    //$updateresult = mysqli_query($con, "UPDATE spots SET title= '".$title."' WHERE id = ".$id);
}


}

//// New - http://pastebin.com/yfB1GiJf
// $result = get_show_name(rid_extension($file));
// $tvdb_sseries_info = get_tvdb_seriesinfo($cleanshowname);
//    if ($tvdb_series_info === false) {
//            return array('status' => '1', 'output' => $output);
//    }
//$output .= "TheTVDB Series Name: " . $tvdb_series_info['name'] . "\n";
//$seriesName = $tvdb_series_info['name'];
//    $output .= "TheTVDB Series ID: " . $tvdb_series_info['id'] . "\n";
//    $tvdb_episode_info = get_tvdb_episodeinfo($tvdb_series_info['id'], $episodearray['res'], $seasonarray['res']);
//    if ($tvdb_episode_info === false) {
//            return array('status' => '2', 'output' => $output);
//    }
//    $output .= "TheTVDB Series Season: " . $tvdb_episode_info['season'] . "\n";
//    $output .= "TheTVDB Series Episode: " . $tvdb_episode_info['episode'] . "\n";
//    $new_filename = gen_proper_filename($file, $tvdb_series_info['name'], $tvdb_episode_info['episode'], $tvdb_episode_info['season']);
                
function gen_proper_filename($input, $name, $episode, $season) {
        $delimiter = '.';
        $extension = get_extension($input);
        if ($episode > 99) {
                $string = 'S' . str_pad($season, 2, "0", STR_PAD_LEFT) . 'E' . str_pad($episode, 3, "0", STR_PAD_LEFT);
        } else {
                $string = 'S' . str_pad($season, 2, "0", STR_PAD_LEFT) . 'E' . str_pad($episode, 2, "0", STR_PAD_LEFT);
        }
  //[TheTVDB Series Name].[season episode].[extension]
        $output = $name . $delimiter . $string . $extension;
        return $output;
}
 
function get_tvdb_seriesinfo($input) {
        $thetvdb = "http://www.thetvdb.com/";
        $result = file_get_contents($thetvdb . 'api/GetSeries.php?seriesname='.urlencode($input));
        $postemp1 = strpos($result, "<seriesid>") + strlen("<seriesid>");
        $postemp2 = strpos($result, "<", $postemp1);
        $seriesid = substr($result, $postemp1, $postemp2 - $postemp1);
        if (is_numeric($seriesid) === false) {
                return false;
        }
        $postemp1 = strpos($result, "<SeriesName>") + strlen("<SeriesName>");
        $postemp2 = strpos($result, "<", $postemp1);
        $seriesname = substr($result, $postemp1, $postemp2 - $postemp1);
        $tvdb = array('id' => $seriesid, 'name' => $seriesname);
        return $tvdb;
}
 
function get_tvdb_episodeinfo($seriesid, $episode, $season) {
        if (empty($season)) {
                $thetvdb = "http://www.thetvdb.com/";
                $result = file_get_contents($thetvdb . 'api/F0A9519B01D1C096/series/'.$seriesid.'/absolute/'.$episode);
                if ($result === false) {
                        return false;
                }
                $postemp1 = strpos($result, "<EpisodeNumber>") + strlen("<EpisodeNumber>");
                $postemp2 = strpos($result, "<", $postemp1);
                $episodenumber = substr($result, $postemp1, $postemp2 - $postemp1);
                $postemp1 = strpos($result, "<SeasonNumber>") + strlen("<SeasonNumber>");
                $postemp2 = strpos($result, "<", $postemp1);
                $episodeseason = substr($result, $postemp1, $postemp2 - $postemp1);
                $tvdb = array('episode' => $episodenumber, 'season' => $episodeseason);
        } else {
                $tvdb = array('episode' => $episode, 'season' => $season);
        }
        return $tvdb;
}
 
function get_show_name($input) {
        $pattern = '/' . '\[[^]]+\]|\([^]]+\)' . '/i';
        $result = preg_replace($pattern,"",$input);
        $result = str_replace("-", " ",$result);
        $result = str_replace("_", " ",$result);
        $result = str_replace(".", " ",$result);
        // remove double spaces in the middle
        while (sizeof ($array=explode ("  ",$result)) != 1)
        {
                 $result = implode (" ",$array);
        }
        return trim($result);
}
 
function rid_extension($thefile) {
        if (strpos($thefile,'.') === false) {
                return $thefile;
        } else {
                return substr($thefile, 0, strrpos($thefile,'.'));
        }
}
 
function get_extension($thefile) {
        return substr($thefile, strrpos($thefile,'.'));
}
 
function get_episode_number($input) {
        if (preg_match('/' . '(E|e)([0-9]+)' . '/', $input, $episodenumber) > 0) {
                $episodenumber = array('del' => $episodenumber[0], 'res' => $episodenumber[2]);
                return $episodenumber;
        } else {
                preg_match_all('/' . '[0-9]+' . '/', $input, $matches);
                //Kijk voor alle episodes
                $matches = $matches[0];
                for ($i=0; $i < count($matches); $i++) {
                        $lastnum = $matches[$i];
                }
                $lastnum = array('del' => $lastnum, 'res' => $lastnum);
                return $lastnum;
        }
}
 
function get_season_number($input) {
        $pattern = '/' . '(S|s)([0-9]+)' . '/';
        if (preg_match($pattern, $input, $match) > 0) {
                $match = array('del' => $match[0], 'res' => $match[2]);
                return $match;
        } else {
                return false;
        }
}
 
function rec_listFiles( $from = '.')
{
    if(! is_dir($from))
        return false;
   
    $files = array();
    if( $dh = opendir($from))
    {
        while( false !== ($file = readdir($dh)))
        {
            // Skip '.' and '..'
            if( $file == '.' || $file == '..')
                continue;
            $path = $from . '/' . $file;
            if( is_dir($path) )
                $files=array_merge($files,rec_listFiles($path));
            else
                $files[] = $path;
        }
        closedir($dh);
    }
    return $files;
}


?>
