# Pay Calculator

hrs = input("Number of Hours Per Week?")
rate = input("Pay Rate?")
weekly_gross_pay = float(hrs) * float(rate)
yearly_gross_pay = float(hrs) * float(rate) * 52
monthly_gross_pay = yearly_gross_pay / 12

# Taxes calculated assuming an average baseline 15% tax rate
weekly_net_pay = int(weekly_gross_pay) * .85
monthly_net_pay = int(monthly_gross_pay) * .85
yearly_net_pay = int(yearly_gross_pay) * .85

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