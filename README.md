# Long-Term Rainfall Analysis in South East Queensland (R)

## Overview
This project presents a comprehensive statistical and spatial analysis of long-term precipitation patterns in South East Queensland (SEQ) using historical weather station data spanning more than 110 years. The analysis is implemented in R and focuses on data preprocessing, exploratory visualisation, summary statistics, and hypothesis testing.

## Objectives
- Identify SEQ weather stations with long-term precipitation records  
- Visualise spatial distribution of stations across the region  
- Analyse rainfall distributions using descriptive statistics  
- Investigate extreme rainfall events at selected post office stations  
- Test whether rainfall occurrences are uniformly distributed across weekdays  

## Data Sources
- **Station Metadata**: Geographic coordinates, elevation, observation period, and recorded elements  
- **Daily Station Data**: Historical daily precipitation (PRCP) records  

(Data files are expected to be placed in the project directory or updated to local paths.)

## Tools and Libraries
The analysis is conducted using R with the following packages:
- `dplyr` – data manipulation  
- `ggplot2` – visualisation  
- `maps` – geographic mapping  
- `lubridate` – date handling  

## Project Structure
├── data/
│ ├── ghcnd_meta_data.csv
│ └── station_data.csv
├── scripts/
│ └── rainfall_analysis.R
├── figures/
│ └── generated_plots.png
├── README.md


## Key Analyses
- Filtering stations with ≥110 years of precipitation data  
- Mapping SEQ weather stations using latitude and longitude  
- Mean and median rainfall calculations excluding zero values  
- Boxplot analysis with log-transformed precipitation values  
- Identification of top five extreme rainfall events  
- Chi-square goodness-of-fit test for weekday rainfall distribution  

## Key Findings
- Several SEQ stations provide highly reliable long-term rainfall records  
- Rainfall distributions are positively skewed with extreme outliers  
- No statistically significant evidence suggests rainfall occurs more frequently on specific weekdays  

## Reproducibility
To reproduce the analysis:
1. Install required R packages  
2. Update file paths to the data directory  
3. Run the main R script in sequence  

## Author
This project was developed as part of an academic assignment focusing on applied statistical analysis and environmental data interpretation using R.

## License
This repository is intended for academic and educational use.

