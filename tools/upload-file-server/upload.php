<?php

ini_set("upload_max_filesize", "10240M");
ini_set("post_max_size", "10240M");
ini_set("memory_limit", "10240M");
ini_set("max_input_time", "600");
ini_set("max_execution_time", "600");
ini_set("max_input_vars", "1000");

echo ini_get('upload_max_filesize');
echo ini_get('post_max_size');


move_uploaded_file($_FILES['upload_name']['tmp_name'], $_FILES['upload_name']['name']);
