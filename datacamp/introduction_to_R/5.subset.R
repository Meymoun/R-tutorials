# Make sure planet_df is loaded into the workspace

# Select planets with rings
subset(planets_df, subset = rings)

# Select planets with diameter < 1
subset(planets_df, subset = diameter < 1)