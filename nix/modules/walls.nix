{ inputs, ... }: {
  home.file."Pictures/Wallpapers" = {
    source = inputs.walls;   # path fetched & pinned in flake.lock
    recursive = true;        # copy the whole tree (as a symlinked dir)
  };
}

