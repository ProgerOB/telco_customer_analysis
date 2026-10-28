-- ==========================================
-- Файл бизнес-запросов для анализа оттока
-- База данных: telco_churn_cleaned.db
-- Цель: проверить гипотезы о связи оттока с типом контракта, стажем и услугами.
-- ==========================================

-- 1. Какой тип контракта генерирует наибольший отток?
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END) * 100, 2) AS churn_rate_pct
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- 2. Сколько денег мы теряем из-за ухода клиентов?
SELECT 
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_lost,
    ROUND(SUM(TotalCharges), 2) AS total_revenue_lost,
    COUNT(*) AS churned_count
FROM telco_churn
WHERE Churn = 'Yes';

-- 3. Как отток зависит от стажа?
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 мес'
        WHEN tenure <= 24 THEN '13-24 мес'
        WHEN tenure <= 48 THEN '25-48 мес'
        ELSE '49+ мес'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0.0 END) * 100, 2) AS churn_rate_pct
FROM telco_churn
GROUP BY tenure_group
ORDER BY 
    CASE 
        WHEN tenure_group = '0-12 мес' THEN 1
        WHEN tenure_group = '13-24 мес' THEN 2
        WHEN tenure_group = '25-48 мес' THEN 3
        ELSE 4
    END;