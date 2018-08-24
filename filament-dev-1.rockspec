package = "filament"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/Guard13007/Filament.git"
}
description = {
   homepage = "https://github.com/Guard13007/Filament",
   license = "MIT license"
}
build = {
   type = "builtin",
   modules = {
      filament = "filament.lua"
   }
}
