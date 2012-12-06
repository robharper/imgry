# Imgry

A Ruby gem for fast image resizing/cropping designed for JRuby with MRI support.

Imgry provides an elegant interface and optimizations to third party libraries: Imgscalr, ImageVoodoo and MiniMagick. The library was designed to work as fast as possible under JRuby, and it does, from what we've seen it outperforms any other JRuby image resizing libraries, if it doesn't, please show us and let's improve it!

It's also convienient for teams that work between MRI and JRuby, working seamlessly across development/production app environments.

We've also implemented ImageMagick/GraphicsMagick's geometry for defining sizes such as "500x", "300x200!", "256x100>", etc. This works consistently across all image processors.

# Authors

* Peter Kieltyka
* Haifeng Cao

# License

MIT License - Copyright (c) 2007-2012 Nulayer Inc.
