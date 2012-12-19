Pseudohelp.configure do |config|
  config.extra_help = {
    markdown: {
      'Code' => {
        'Code block' => {
          'input' => <<-mkdn.strip_heredoc
            ```ruby
            def greeting
              puts 'Hello! Hola! Bom dia!'
            end
            ```
            mkdn
        }
      }
    },
    bbcode: {
      code: {
        'Code with lang' => {
          'input' => '[code:javascript]function(){ return true; }[/code]'
        }
      },
      spoilers: {
        'Spoilers' => {
          'input' => '[spoiler]Soylent green is people.[/spoiler]',
          'output' => '<blockquote class="spoiler">Soylent green is people.</blockquote>'
        }
      },
      videos: {
        'Youtube' => {
          'input' => '[youtube]http://www.youtube.com/watch?v=123456[/youtube]',
          'output' => '<img src="//www.skibowl.com/winter/sites/all/themes/winter-2012/images/youtube_player.jpg" />'
        }
      }
    },
    thredded: {
      images: {
        'Next image attached to post' => {
          'input' => '[t:img]',
          'output' => ''
        },
        'Second image attached to post' => {
          'input' => '[t:img=2]',
          'output' => ''
        },
        'Align second and third images attached to post' => {
          'input' => '[t:img=2 left] [t:img=3 right]',
          'output' => ''
        },
        'Specify size on the fourth attached image' => {
          'input' => '[t:img=4 200x200]',
          'output' => ''
        }
      }
    }
  }
end
