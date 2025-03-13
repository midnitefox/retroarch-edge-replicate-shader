#version 120

// Standard RetroArch uniforms
uniform sampler2D source;       // Input texture (Game Boy game)
uniform vec2 texture_size;      // Size of the input texture (160x144 for Game Boy)
uniform vec2 output_size;       // Size of the output display (1240x1080 for Retroid Pocket Classic)

// Varying inputs from the vertex shader
varying vec2 texCoord;          // Texture coordinates for sampling the input texture

void main()
{
    // Step 1: Calculate the scaling and positioning of the game content
    // Game Boy aspect ratio is 10:9 (160x144), screen aspect ratio is 31:27 (~10⅓:9)
    float game_aspect = 10.0 / 9.0;              // Game Boy aspect ratio
    float screen_aspect = 31.0 / 27.0;           // Screen aspect ratio
    float scale_factor = output_size.y / texture_size.y; // Assume RetroArch scales to fit height
    float scaled_width = texture_size.x * scale_factor;  // Width of scaled game content in pixels
    float scaled_height = texture_size.y * scale_factor; // Height of scaled game content in pixels

    // Step 2: Calculate the centered position of the game content
    float offset_x = (output_size.x - scaled_width) / 2.0; // Offset for centering horizontally
    float offset_y = (output_size.y - scaled_height) / 2.0; // Offset for centering vertically

    // Step 3: Convert fragment coordinates to texture coordinates
    // Current fragment position in screen space
    vec2 frag_pos = gl_FragCoord.xy;
    // Normalize to [0, 1] range based on output resolution
    vec2 norm_pos = frag_pos / output_size;

    // Step 4: Determine if the current fragment is within the game content area
    float game_left = offset_x;
    float game_right = offset_x + scaled_width;
    float game_bottom = offset_y;
    float game_top = offset_y + scaled_height;

    // Step 5: Handle the three cases: left black bar, game content, right black bar
    if (frag_pos.x < game_left) {
        // Left black bar: Replicate the leftmost column of the game content
        vec2 sample_coord = vec2(0.0, texCoord.y); // Sample the leftmost column
        gl_FragColor = texture2D(source, sample_coord);
        
        // Optional: Uncomment for smooth blending over 10 pixels
        /*
        float blend_factor = (game_left - frag_pos.x) / 10.0;
        vec4 edge_color = texture2D(source, sample_coord);
        gl_FragColor = mix(edge_color, vec4(0.0, 0.0, 0.0, 1.0), clamp(blend_factor, 0.0, 1.0));
        */
    }
    else if (frag_pos.x >= game_left && frag_pos.x <= game_right &&
             frag_pos.y >= game_bottom && frag_pos.y <= game_top) {
        // Inside game content: Preserve the original pixel
        gl_FragColor = texture2D(source, texCoord);
    }
    else if (frag_pos.x > game_right) {
        // Right black bar: Replicate the rightmost column of the game content
        vec2 sample_coord = vec2(1.0, texCoord.y); // Sample the rightmost column
        gl_FragColor = texture2D(source, sample_coord);
        
        // Optional: Uncomment for smooth blending over 10 pixels
        /*
        float blend_factor = (frag_pos.x - game_right) / 10.0;
        vec4 edge_color = texture2D(source, sample_coord);
        gl_FragColor = mix(edge_color, vec4(0.0, 0.0, 0.0, 1.0), clamp(blend_factor, 0.0, 1.0));
        */
    }
    else {
        // Outside vertical bounds (unlikely, but default to black)
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}