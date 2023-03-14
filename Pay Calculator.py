# Adjustable Inputs Allow Flexible Calculations

print(" ")
hrs = input("Estimated Hours Per Week: ")
print(" ")
p_rate = input("Pay Rate: ")
print(" ")
t_rate = input("Tax Rate: ")


# Gross Pay Calculations

adjusted_t_rate = int(t_rate) / 100
weekly_gross_pay = int(hrs) * int(p_rate)
yearly_gross_pay = int(hrs) * int(p_rate) * 52
monthly_gross_pay = yearly_gross_pay / 12


# Net Pay Calculations

weekly_net_pay = round(weekly_gross_pay * (1-adjusted_t_rate), 2 )
monthly_net_pay = round(monthly_gross_pay * (1-adjusted_t_rate), 2 )
yearly_net_pay = round(yearly_gross_pay * (1-adjusted_t_rate), 2 )

## print(adjusted_t_rate)
print(" ")
print("~~~~~~~~")
print(" ")
print("Pay Per Week:")
print("Gross: $"+str(weekly_gross_pay))
print("After Estimated Taxes: $"+str(weekly_net_pay))
print(" ")
print("Pay Per Month:")
print("Gross: $"+str(monthly_gross_pay))
print("After Estimated Taxes: $"+str(monthly_net_pay))
print(" ")
print("Pay Per Year:")
print("Gross: $"+str(yearly_gross_pay))
print("After Estimated Taxes: $"+str(yearly_net_pay))
print(" ")
