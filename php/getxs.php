<?
    list(,$zaid,$file,$output) = $argv;

    if (!($h = @fopen($file, 'r'))) {
        die('File not found: '.$file);
    }

    while (!feof($h)) {
        $s = fgets($h);

        if (strncmp(' '.$zaid, $s ,strlen($zaid)+1) == 0) {

            print $s . fgets($h);

            while (!feof($h)) {

                $s = fgets($h);

                if (strncmp('  ',$s,2)==0) {
                    print $s;
                } else {
                    die;
                }
            }
        }

    }
    fclose($h);
?>