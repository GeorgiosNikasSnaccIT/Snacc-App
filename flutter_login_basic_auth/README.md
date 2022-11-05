# snaccit_login

Flutter Login Page for snacc-it dev instance.

## Included Structure

- Main: Call Login Form or Home Page. If there is basic authentication data in secure storage -> Home Page, if not -> Login Form.

- SnaccITLoginForm: Call get method with email/address using REST API endpoint /checkLogin and 
if authorization success store basic authentication data in secure storage.

- ExpenseHome: A button to logout, if it is clicked, the stored basic authentication data would be deleted and go back to login form.

- API/SNAPI

- Model/User

- Others/colors: customized material color for theme, because there is no that kind deep blue in material color.

For the information of flutter secure storage plugin, here is a short introduction:
[Using Secure Storage in Flutter](https://newbiecoders.hashnode.dev/using-secure-storage-in-flutter)
