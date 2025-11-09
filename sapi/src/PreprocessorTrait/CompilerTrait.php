<?php

namespace SwooleCli\PreprocessorTrait;

trait CompilerTrait
{
    protected string $ar = 'ar';

    protected string $as = 'as';

    public function setCCOMPILER(string $cc): static
    {
        $this->cCompiler = $cc;
        return $this;
    }

    public function setCXXCOMPILER(string $cxx): static
    {
        $this->cppCompiler = $cxx;
        return $this;
    }

    public function getCCOMPILER(): string
    {
        return $this->cCompiler;
    }

    public function getCXXCOMPILER(): string
    {
        return $this->cppCompiler;
    }

    public function setLinker(string $ld): static
    {
        $this->lld = $ld;
        return $this;
    }

    public function getLinker(): string
    {
        return $this->lld;
    }

    public function setAR(string $ar): static
    {
        $this->ar = $ar;
        return $this;
    }

    public function setAS(string $as): static
    {
        $this->as = $as;
        return $this;
    }
}
