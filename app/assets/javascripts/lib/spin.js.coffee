#
# 
#You can now create a spinner using any of the variants below:
# 
#$("#el").spin(); // Produces default Spinner using the text color of #el.
#$("#el").spin("small"); // Produces a 'small' Spinner using the text color of #el.
#$("#el").spin("large", "white"); // Produces a 'large' Spinner in white (or any valid CSS color).
#$("#el").spin({ ... }); // Produces a Spinner using your custom settings.
# 
#$("#el").spin(false); // Kills the spinner.
# 
#
(($) ->
  $.fn.spin = (opts, color) ->
    if arguments.length is 1 and opts is false
      return @each(->
        $this = $(this)
        data = $this.data()
        if data.spinner
          data.spinner.stop()
          delete data.spinner
      )
    presets =
      tiny:
        lines: 8
        length: 2
        width: 2
        radius: 3

      small:
        lines: 8
        length: 4
        width: 3
        radius: 5

      large:
        lines: 10
        length: 8
        width: 4
        radius: 8

    if Spinner
      @each ->
        $this = $(this)
        data = $this.data()
        if data.spinner
          data.spinner.stop()
          delete data.spinner
        if opts isnt false
          if typeof opts is "string"
            if opts of presets
              opts = presets[opts]
            else
              opts = {}
            opts.color = color  if color
          data.spinner = new Spinner($.extend(
            color: $this.css("color")
          , opts)).spin(this)

    else
      throw "Spinner class not available."
) jQuery