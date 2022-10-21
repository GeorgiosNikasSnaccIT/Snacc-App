# snaccit_login

Flutter Login Page for snacc-it dev instance.

## Included Widgets

- Main: Call Login Form or Home Page. If there is basic authentication data in secure storage -> Home Page, if not -> Login Form.
- SnaccITLoginForm: Call get method with email/address using REST API endpoint /checkLogin and 
if authorization success store basic authentication data in secure storage.
- ExpenseHome: A button to logout, if it is clicked, the stored basic authentication data would be deleted and go back to login form.

For the information of flutter secure storage plugin, here is a short introduction:
[online documentation](https://newbiecoders.hashnode.dev/using-secure-storage-in-flutter)
