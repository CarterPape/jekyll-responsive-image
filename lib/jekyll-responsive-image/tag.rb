module Jekyll
    module ResponsiveImage
        class Tag < Liquid::Tag
            
            VALID_SYNTAX = Jekyll::Tags::IncludeTag::VALID_SYNTAX.freeze
            VARIABLE_SYNTAX = Jekyll::Tags::IncludeTag::VARIABLE_SYNTAX.freeze
            
            FULL_VALID_SYNTAX = Jekyll::Tags::IncludeTag::FULL_VALID_SYNTAX.freeze
            VALID_FILENAME_CHARS = Jekyll::Tags::IncludeTag::VALID_FILENAME_CHARS.freeze
            INVALID_SEQUENCES = Jekyll::Tags::IncludeTag::INVALID_SEQUENCES.freeze
            
            def initialize(tag_name, markup, tokens)
                super
                markup  = markup.strip
                matched = markup.match(VARIABLE_SYNTAX)
                if matched
                    @file = matched["variable"].strip
                    @params = matched["params"].strip
                else
                    @file, @params = markup.split(%r!\s+!, 2)
                end
                validate_params if @params
                @tag_name = tag_name
            end
            
            def syntax_example
                return "{% #{@tag_name} 'file.ext' param=\"value\" param2=variable %}"\
                    "\nor"\
                    "\n{% #{@tag_name} {{ variable }} param='value' param2=variable %}"
            end
            
            def parse_params(context)
                params = {}
                @params.scan(VALID_SYNTAX) do |key, d_quoted, s_quoted, variable|
                    value = if d_quoted
                                d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
                            elsif s_quoted
                                s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
                            elsif variable
                                context[variable]
                            end
                    
                    params[key] = value
                end
                params
            end
            
            def validate_file_name(file)
                if INVALID_SEQUENCES.match?(file) || !VALID_FILENAME_CHARS.match?(file)
                raise ArgumentError, <<~MSG
                    Invalid syntax for include tag. File contains invalid characters or sequences:
                    
                    #{file}
                    
                    Valid syntax:
                    
                    #{syntax_example}
                    
                MSG
                end
            end
            
            def validate_params
                unless FULL_VALID_SYNTAX.match?(@params)
                raise ArgumentError, <<~MSG
                    Invalid syntax for include tag:
                    
                    #{@params}
                    
                    Valid syntax:
                    
                    #{syntax_example}
                    
                MSG
                end
            end
            
            def render_variable(context)
                Liquid::Template.parse(@file).render(context) if VARIABLE_SYNTAX.match?(@file)
            end
            
            def render(context)
                file = render_variable(context) || @file
                params = @params ? parse_params(context) : nil
                Renderer.new(context.registers[:site], file, params).render_responsive_image
            end
        end
    end
end
