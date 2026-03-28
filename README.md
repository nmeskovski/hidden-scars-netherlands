# Hidden Scars: An Analysis of Gender Health Inequalities in the Netherlands

> **BSc Applied Economics** · Corvinus University of Budapest · 2024  
> **Course:** Project 1 Research · **Instructor:** Kovács Emese

---

## Abstract

This paper investigates gender-based health disparities in the Netherlands using data from the 2013 EU-SILC (Statistics on Income and Living Conditions) survey. Despite the Netherlands' high healthcare standards, significant health outcome disparities persist across gender lines. Using ordinal logistic regression on a cleaned sample of **1,521 working individuals**, the study finds that **gender is the only statistically significant predictor** of self-reported health status — women are 6.1% less likely to report 'very good' health and more likely to report worse health across all categories compared to men.

---

## Research Hypothesis

> *Self-reported general health status in the Netherlands is significantly influenced by gender, with conditioning factors including work intensity, occupation, age, and marital status.*

---

## Key Findings

| Variable | Coefficient | P-Value | Significant? |
|---|---|---|---|
| Female | 0.38 | **0.00** | ✅ Yes |
| Not Married | 0.02 | 0.86 | ❌ No |
| Business Professional (vs. Teaching) | 0.12 | 0.45 | ❌ No |
| Age | 0.00 | 0.96 | ❌ No |

**Marginal Effects for Female (vs. Male):**
- 6.1% *less* likely to report **Very Good** health
- 5.2% *more* likely to report **Fair** health
- 1.3% *more* likely to report **Bad** health
- 0.3% *more* likely to report **Very Bad** health

---

## Data

- **Source:** [Eurostat EU-SILC Microdata, Netherlands, 2013](https://ec.europa.eu/eurostat/web/microdata/public-microdata/statistics-on-income-and-living-conditions)
- **Initial sample:** ~18,157 working individuals aged 19–81
- **Final sample:** 1,521 individuals (after cleaning for missing key variables)
- **Note:** The dataset uses synthetic data to preserve respondent privacy

### Key Variables

| Variable | Description | Coding |
|---|---|---|
| General Health | Self-reported health status | 1 (Very Good) → 5 (Very Bad) |
| Female | Gender indicator | 0 = Male, 1 = Female |
| Marital Status | Simplified binary | 0 = Previously married, 1 = Never married |
| Occupation | ISCO-08 classification | 5 major groups |
| Age | Derived from birth year | Continuous |

> **Note:** "Hours Worked Weekly" was excluded after failing the parallel line assumption in the Brant Test (p = 0.009 < 0.05).

---

## Methodology

1. **Ordinal Logistic Regression** — used given the ordered nature of the health status variable
2. **Brant Test** — to verify the parallel lines assumption required for ordinal logistic regression
3. **Average Marginal Effects** — to interpret the practical magnitude of each variable's impact

**Model Equation:**

```
logit(P(Y ≤ j)) = α_j + β₁·Female + β₂·MaritalStatus + β₃·Occupation + β₄·Age + ε
```

---

## Repository Structure

```
hidden-scars-netherlands/
│
├── README.md                          # This file
├── Hidden_Scars_in_The_Netherlands.pdf  # Full paper
├── General_Heath_DatasetDoFile.do     # Stata do-file (data cleaning & analysis)
└── NL_2013p_EUSILC.csv               # EU-SILC dataset (Netherlands, 2013)
```

---

## How to Reproduce

1. Open **Stata**
2. Load `NL_2013p_EUSILC.csv` as your working dataset
3. Run `General_Heath_DatasetDoFile.do` — this handles data cleaning, variable recoding, the ordinal logistic regression, Brant test, and marginal effects estimation

---

## Authors

| Name | Institution |
|---|---|
| **Meshkovski Nikola** | Corvinus University of Budapest |
| Yarovoy Daniil | Corvinus University of Budapest |
| Katona Balázs Levente | Corvinus University of Budapest |
| Kákonyi Bence | Corvinus University of Budapest |

---

## References

- Artazcoz et al. (2016). Long working hours and health in Europe. *Health & Place*, 40, 161–168.
- Bertens & Vonk (2020). Small steps, big change. *Social Science & Medicine*, 266.
- Broom, D. (2008). Gender in/and/of health inequalities. *Australian Journal of Social Issues*, 43, 11–28.
- Čehovin Zajc & Kohont (2017). Impacts of Work Intensity on Employees' Quality of Work, Life, and Health. *Teorija in Praksa*, 54.
- Eurostat (2024). EU-SILC Microdata, Netherlands 2013. https://ec.europa.eu/eurostat/web/microdata/public-microdata/statistics-on-income-and-living-conditions
- Jenkinson, S. (2001). Health inequalities and deprivation. *British Journal of General Practice*, 51(470).
- Stephan, F. (1941). Stratification in Representative Sampling. *Journal of Marketing*, 6, 38–46.
- Winchester, N. (2021). Women's Health Outcomes: Is there a gender gap? House of Lords Library.

---

## License

This project is for academic purposes. The EU-SILC data is subject to [Eurostat's microdata access conditions](https://ec.europa.eu/eurostat/web/microdata/public-microdata/statistics-on-income-and-living-conditions).
