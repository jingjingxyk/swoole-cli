<?php

$phar=new Phar("index.phar",0,"index.phar");
$phar->buildFromDirectory(dirname(__FILE__)."/src");
$phar->setDefaultStub("index.php","index.php");
