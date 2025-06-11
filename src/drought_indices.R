#SPI
calculate_spi <- function(df, period = 1){
  
  df_wide <- df[, c(2, 3, 4, 10)] |>
    mutate(day_label = paste0("d", day)) |>
    select(-day) |>
    pivot_wider(names_from = day_label, values_from = Precipitation)
  
  spi <- precintcon.spi.analysis(as.daily(df_wide), period = 1)
}

#plot spi against monthly precipitation
plot_spi <- function(spi_df, p_df, bg = bg_grob){
  ggplot(spi_df, aes(x = month)) +
    annotation_custom(
      grob = bg,
      xmin = -Inf, xmax = Inf,
      ymin = 0, ymax = 6
    ) +
    geom_col(
      data = p_df,
      aes(y = (Precipitation / 150) * 6),  # Range: 0 to 6
      fill = "lightblue",
      alpha = 0.5
    ) +
    geom_line(
      aes(y = spi + 3),  # Shift SPI line up to match same scale
      color = "red2",
      linewidth = 0.8,
      linetype = "solid",
      na.rm = FALSE
    ) +
    scale_y_continuous(
      name = "SPI",
      limits = c(0, 6),
      breaks = seq(0, 6, 1),
      labels = seq(-3, 3, 1),  # Remap ticks to SPI values
      sec.axis = sec_axis(
        transform = ~ . / 6 * 150,
        name = "Precipitation (mm)",
        breaks = seq(0, 150, 25)
      )
    ) +
    theme_minimal()
}

bg_img <- readPNG("extra/spi_scale_bg.png")
bg_grob <<- rasterGrob(bg_img, width = unit(1, "npc"), height = unit(1, "npc"))
