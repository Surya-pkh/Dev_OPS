-- Simple and Elegant Conky Time and Date Widget
-- Save this as ~/.conkyrc

conky.config = {
    -- Basic settings
    background = true,
    update_interval = 1.0,
    double_buffer = true,
    no_buffers = true,
    text_buffer_size = 2048,
    
    -- Window specifications
    own_window = true,
    own_window_type = 'desktop',
    own_window_transparent = true,
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    own_window_argb_visual = true,
    own_window_argb_value = 150,
    
    -- Positioning
    alignment = 'top_right',
    gap_x = 50,
    gap_y = 50,
    minimum_width = 280,
    minimum_height = 200,
    
    -- Graphics settings
    draw_shades = false,
    draw_outline = false,
    draw_borders = false,
    border_width = 0,
    
    -- Text settings
    use_xft = true,
    font = 'Roboto:size=12',
    xftalpha = 0.8,
    uppercase = false,
    
    -- Color settings
    default_color = 'white',
    default_shade_color = '000000',
    default_outline_color = '000000',
    
    -- Misc
    cpu_avg_samples = 2,
    net_avg_samples = 2,
};

conky.text = [[
${alignc}${color 9370DB}${font Roboto:bold:size=70}${time %H:%M}${font}${color}
${alignc}${color E6E6FA}${font Roboto:size=20}${time %A}${font}${color}
${alignc}${color E6E6FA}${font Roboto:size=18}${time %d %B %Y}${font}${color}

${alignc}${color 9370DB}${font Roboto:bold:size=12}SYSTEM INFO${font}${color}
${color E6E6FA}${hr 2}${color}
${color E6E6FA}Uptime:${alignr}${uptime}${color}
${color E6E6FA}CPU:${alignr}${cpu}%${color}
${color 9370DB}${cpubar 4}${color}
${color E6E6FA}RAM:${alignr}${mem} / ${memmax}${color}
${color 9370DB}${membar 4}${color}
]];
