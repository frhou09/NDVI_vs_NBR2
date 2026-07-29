# load packages
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Read data
df <- read.csv("D:/NDVI/cleaned_output.csv")

# Handle the single NA in NBR 2026 (row 369)
df <- df %>%
  mutate(NBR.2026 = ifelse(is.na(NBR.2026), mean(NBR.2026, na.rm = TRUE), NBR.2026))

# GRAPH 1: correlation_trend_line.png
# Trend of Pearson correlation coefficients

correlation_data <- df %>%
  summarise(
    `2021` = cor(NDVI.2021, NBR.2021, use = "complete.obs"),
    `2022` = cor(NDVI.2022, NBR.2022, use = "complete.obs"),
    `2023` = cor(NDVI.2023, NBR.2023, use = "complete.obs"),
    `2024` = cor(NDVI.2024, NBR.2024, use = "complete.obs"),
    `2025` = cor(NDVI.2025, NBR.2025, use = "complete.obs"),
    `2026` = cor(NDVI.2026, NBR.2026, use = "complete.obs")
  ) %>%
  pivot_longer(cols = everything(), names_to = "year", values_to = "correlation") %>%
  mutate(year = as.numeric(year))

delta_cor_data <- df %>%
  mutate(
    dNDVI.2022 = NDVI.2022 - NDVI.2021,
    dNDVI.2023 = NDVI.2023 - NDVI.2022,
    dNDVI.2024 = NDVI.2024 - NDVI.2023,
    dNDVI.2025 = NDVI.2025 - NDVI.2024,
    dNDVI.2026 = NDVI.2026 - NDVI.2025,
    dNBR.2022 = NBR.2022 - NBR.2021,
    dNBR.2023 = NBR.2023 - NBR.2022,
    dNBR.2024 = NBR.2024 - NBR.2023,
    dNBR.2025 = NBR.2025 - NBR.2024,
    dNBR.2026 = NBR.2026 - NBR.2025
  ) %>%
  summarise(
    `2022` = cor(dNDVI.2022, dNBR.2022, use = "complete.obs"),
    `2023` = cor(dNDVI.2023, dNBR.2023, use = "complete.obs"),
    `2024` = cor(dNDVI.2024, dNBR.2024, use = "complete.obs"),
    `2025` = cor(dNDVI.2025, dNBR.2025, use = "complete.obs"),
    `2026` = cor(dNDVI.2026, dNBR.2026, use = "complete.obs")
  ) %>%
  pivot_longer(cols = everything(), names_to = "year", values_to = "correlation") %>%
  mutate(year = as.numeric(year))

p_correlation <- ggplot() +
  geom_line(data = correlation_data, aes(x = year, y = correlation, color = "NDVI vs NBR"), 
            size = 1.2, linetype = "solid") +
  geom_point(data = correlation_data, aes(x = year, y = correlation, color = "NDVI vs NBR"), 
             size = 3) +
  geom_line(data = delta_cor_data, aes(x = year, y = correlation, color = "dNDVI vs dNBR"), 
            size = 1.2, linetype = "dashed") +
  geom_point(data = delta_cor_data, aes(x = year, y = correlation, color = "dNDVI vs dNBR"), 
             size = 3) +
  scale_color_manual(name = "Comparison",
                     values = c("NDVI vs NBR" = "#2E8B57", 
                                "dNDVI vs dNBR" = "#D2691E")) +
  scale_x_continuous(breaks = seq(2021, 2026, 1)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
  labs(x = "Year", y = "Correlation Coefficient (r)") +
  theme_minimal() +
  theme(legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

print(p_correlation)

# Save Graph 1
ggsave("correlation_trend_line.png", plot = p_correlation, width = 8, height = 5, dpi = 300)

# GRAPH 2: dNDVI_vs_dNBR_scatter_facet.png
# scatter plots by year

delta_scatter <- df %>%
  mutate(
    rand_point_id = row_number(),
    dNDVI_2022 = NDVI.2022 - NDVI.2021,
    dNBR_2022 = NBR.2022 - NBR.2021,
    dNDVI_2023 = NDVI.2023 - NDVI.2022,
    dNBR_2023 = NBR.2023 - NBR.2022,
    dNDVI_2024 = NDVI.2024 - NDVI.2023,
    dNBR_2024 = NBR.2024 - NBR.2023,
    dNDVI_2025 = NDVI.2025 - NDVI.2024,
    dNBR_2025 = NBR.2025 - NBR.2024,
    dNDVI_2026 = NDVI.2026 - NDVI.2025,
    dNBR_2026 = NBR.2026 - NBR.2025
  ) %>%
  select(rand_point_id, starts_with("dNDVI"), starts_with("dNBR"))

scatter_data <- delta_scatter %>%
  pivot_longer(cols = -rand_point_id,
               names_to = "metric_year",
               values_to = "value") %>%
  separate(metric_year, into = c("metric", "year"), sep = "_") %>%
  pivot_wider(names_from = metric, values_from = value) %>%
  mutate(year = as.numeric(year))

p_scatter <- ggplot(scatter_data, aes(x = dNDVI, y = dNBR)) +
  geom_point(alpha = 0.4, size = 1.5, color = "#2C3E50") +
  geom_smooth(method = "lm", se = TRUE, color = "#E74C3C", size = 0.8) +
  facet_wrap(~year, scales = "free", nrow = 1) +
  labs(x = "ΔNDVI", y = "ΔNBR") +
  theme_minimal() +
  theme(strip.text = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 9),
        panel.grid.minor = element_blank())

print(p_scatter)

# save Graph 2
ggsave("dNDVI_vs_dNBR_scatter_facet.png", plot = p_scatter, width = 12, height = 4, dpi = 300)

# GRAPH 4: correlation_dndvi_dnbr.png
# bar plot of dNDVI vs dNBR correlations

p_delta_cor <- ggplot(delta_cor_data, aes(x = as.factor(year), y = correlation, fill = correlation)) +
  geom_bar(stat = "identity", width = 0.6) +
  scale_fill_gradient(low = "#FDEBD0", high = "#E74C3C", guide = "none") +
  geom_hline(yintercept = mean(delta_cor_data$correlation), 
             linetype = "dashed", color = "#2C3E50", size = 0.8) +
  labs(x = "Year", y = "Correlation Coefficient (r)") +
  ylim(0, 1) +
  theme_minimal() +
  theme(axis.text = element_text(size = 11),
        panel.grid.major.x = element_blank())

print(p_delta_cor)

# aave Graph 3
ggsave("correlation_dndvi_dnbr.png", plot = p_delta_cor, width = 7, height = 5, dpi = 300)

# GRAPH 4: comparison_side_by_side.png
# Recovery classification comparison

classify_recovery <- function(ndvi_change, nbr_change) {
  if(ndvi_change > 0 & nbr_change > 0) return("Full")
  else if(ndvi_change > 0 | nbr_change > 0) return("Partial")
  else return("No")
}

recovery_data <- df %>%
  mutate(
    ndvi_change = NDVI.2026 - NDVI.2021,
    nbr_change = NBR.2026 - NBR.2021,
    recovery = mapply(classify_recovery, ndvi_change, nbr_change)
  )

nbr_recovery <- recovery_data %>%
  group_by(recovery) %>%
  summarise(n = n()) %>%
  mutate(percent = round(n / sum(n) * 100, 2),
         index = "NBR")

ndvi_recovery <- recovery_data %>%
  mutate(
    recovery_ndvi = case_when(
      ndvi_change > 0.1 ~ "Full",
      ndvi_change > 0.02 ~ "Partial",
      TRUE ~ "No"
    )
  ) %>%
  group_by(recovery = recovery_ndvi) %>%
  summarise(n = n()) %>%
  mutate(percent = round(n / sum(n) * 100, 2),
         index = "NDVI")

comparison_data <- bind_rows(nbr_recovery, ndvi_recovery) %>%
  mutate(recovery = factor(recovery, levels = c("Full", "Partial", "No")))

p_comparison <- ggplot(comparison_data, aes(x = index, y = percent, fill = recovery)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  geom_text(aes(label = paste0(percent, "%")), 
            position = position_dodge(width = 0.8), 
            vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c("Full" = "#2E8B57", 
                               "Partial" = "#D2691E", 
                               "No" = "#E74C3C")) +
  labs(x = "Index", y = "Percentage") +
  theme_minimal() +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.text = element_text(size = 11, face = "bold"),
        panel.grid.major.x = element_blank())

print(p_comparison)

# Save Graph 4
ggsave("comparison_side_by_side.png", plot = p_comparison, width = 7, height = 5, dpi = 300)

