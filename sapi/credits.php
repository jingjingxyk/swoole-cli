<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>Credits</title>
    <style>
        .product{
            font-size:1rem;
            margin-bottom: 0.5rem;
        }
        .product span{
            margin-left:0.4rem;
        }
    </style>
</head>
<body>
<h1 class="page-title" style="text-align: center">Credits</h1>
<div class="product">
    <span class="title">musl-libc</span>
    <span class="homepage"><a href="http://www.musl-libc.org/">homepage</a></span>
    <span class="docs"><a href="http://musl.libc.org/manual.html">docs</a></span>
    <input type="checkbox" hidden="hidden" id="" />
    <label class="show" tabindex="0"></label>
    <span class="licence" ><a href="http://git.musl-libc.org/cgit/musl/tree/COPYRIGHT">licence</a></span>
</div>
<div class="product">
    <span class="title">php</span>
    <span class="homepage"><a href="https://www.php.net/">homepage</a></span>
    <span class="docs"><a href="https://www.php.net/docs.php">docs</a></span>
    <input type="checkbox" hidden="hidden" id="" />
    <label class="show" tabindex="0"></label>
    <span class="licence" ><a href="https://github.com/php/php-src/blob/master/LICENSE">licence</a></span>
</div>
<?php foreach ($this->libraryList as $item) : ?>
<div class="product">
        <span class="title"><?= $item->name ?></span>
        <span class="homepage"><a href="<?= $item->homePage ?>">homepage</a></span>
        <span class="docs"><a href="<?= $item->homePage ?>">docs</a></span>
        <input type="checkbox" hidden="hidden" id="" />
        <label class="show" tabindex="0"></label>
        <span class="licence" ><a href="<?= $item->license ?>">licence</a></span>
</div>
<?php endforeach; ?>

<?php foreach ($this->extensionList as $item) : ?>
    <?php if (empty($item->license)) : ?>
            <?php continue ?>
    <?php else : ?>
    <div class="product">
        <span class="title">php-ext-<?= $item->name ?></span>
        <span class="homepage"></span>
        <input type="checkbox" hidden="hidden" id="" />
        <label class="show" tabindex="0"></label>
        <div class="licence" ><?= $item->license ?></div>
    </div>
    <?php endif ?>
<?php endforeach;?>
</body>
</html>