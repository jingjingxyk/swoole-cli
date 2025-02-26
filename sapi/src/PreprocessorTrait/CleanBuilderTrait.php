<?php

declare(strict_types=1);

namespace SwooleCli\PreprocessorTrait;

trait CleanBuilderTrait
{
    private array $x_lib_builders = [];
    private array $x_ext_builders = [];

    public function show_ext_deps(string $ext_name): void
    {
        $project_dir = realpath(__DIR__ . '/../../../');
        $ext_is_exists = 0;
        $ext_builders_t = scandir($project_dir . '/sapi/src/builder/extension/');
        $ext_builders = [];
        foreach ($ext_builders_t as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                if ($file === $ext_name . '.php') {
                    $ext_is_exists = 1;
                }
                $ext_builders [] = $file;
            }
        }
        $ext_builders_t = null;
        unset($ext_builders_t);
        $library_builders_t = scandir($project_dir . '/sapi/src/builder/library/');
        $library_builders = [];
        foreach ($library_builders_t as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                $library_builders [] = $file;
            }
        }
        $library_builders_t = null;
        unset($library_builders_t);
        if ($ext_is_exists != 1) {
            echo 'no found ext name : ' . $ext_name;
            exit(0);
        }

        # 获得扩展依赖链
        $this->getDependentExtensionsByExtName($ext_name);
        # 获得库依赖链
        $this->getDependentLibraryByExtName($ext_name);


        echo "=================" . PHP_EOL;
        echo "依赖的扩展:" . PHP_EOL;
        foreach ($this->x_ext_builders as $key => $ext) {
            echo $ext . PHP_EOL;
        }

        echo "=================" . PHP_EOL;
        echo "依赖的库: " . PHP_EOL;
        foreach ($this->x_lib_builders as $key => $lib) {
            echo $lib . PHP_EOL;
        }
        //var_dump($this->x_ext_builders);
        //var_dump($this->x_lib_builders);

        echo "=================" . PHP_EOL;
        $x_ext_builders = array_map(fn ($value) => $value . '.php', $this->x_ext_builders + [$ext_name]);
        $x_lib_builders = array_map(fn ($value) => $value . '.php', $this->x_lib_builders);
        # 求差集 获得不需要的 builder
        $clean_ext_builder = array_diff($ext_builders, $x_ext_builders);
        $clean_lib_builder = array_diff($library_builders, $x_lib_builders);

        //var_dump($clean_ext_builder);
        //var_dump($clean_lib_builder);

        if ($this->getInputOption('with-clean-builder')) {
            $cmd = <<<EOF
cd {$project_dir}
git branch | grep '* ' | awk '{print $2}'
EOF;

            $branch_name = trim(shell_exec($cmd));
            if (!in_array($branch_name, [
                'build-swow-cli',
                'build_native_php',
                'build_native_php_sfx_micro',
                'build_php_7.3',
                'build_php_7.4',
                'build_php_8.0',
                'experiment',
                'experiment-feature',
                'experiment_v4.8.x',
                'new_dev',
                'php-fpm',
                'php-fpm-7.4'
            ])) {
                echo "清理无关的 builder " . PHP_EOL;
                foreach ($clean_ext_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/extension/' . $file);
                }
                foreach ($clean_lib_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/library/' . $file);
                }
                echo "清理 builder 完毕" . PHP_EOL;
            } else {
                echo '不执行清理 builder 操作' . PHP_EOL;
            }
            exit(0);
        }
    }

    private function getDependentExtensionsByExtName($ext_name): void
    {
        $dependentExtensions = $this->extensionMap[$ext_name]->dependentExtensions;
        if (!empty($dependentExtensions)) {
            foreach ($dependentExtensions as $ext) {
                if (in_array($ext, $this->x_ext_builders)) {
                    continue;
                } else {
                    $this->x_ext_builders[] = $ext;
                }
                $this->getDependentExtensionsByExtName($ext);
            }
        }
    }

    private function getDependentLibraryByExtName($ext_name): void
    {
        $deps = $this->extensionMap[$ext_name]->deps;
        if (!empty($deps)) {
            foreach ($deps as $lib) {
                if (in_array($lib, $this->x_lib_builders)) {
                    continue;
                }
                $this->x_lib_builders[] = $lib;
                $this->getDependentLibraryByLibName($lib);
            }
        }
    }

    private function getDependentLibraryByLibName($lib_name): void
    {
        $deps = $this->libraryMap[$lib_name]->deps;
        if (!empty($deps)) {
            foreach ($deps as $lib) {
                if (in_array($lib, $this->x_lib_builders)) {
                    continue;
                }
                $this->x_lib_builders[] = $lib;
                $this->getDependentLibraryByLibName($lib);
            }
        }
    }

}
