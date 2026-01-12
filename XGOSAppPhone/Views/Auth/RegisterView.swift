//
//  RegisterView.swift
//  XGOSAppPhone
//
//  注册界面
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var deviceId: String = ""
    @State private var email: String = ""
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景色
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 标题
                        VStack(spacing: 8) {
                            Text("注册账号")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: Constants.UI.textColor))
                            
                            Text("创建您的 XGOSAPP 账号")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        // 注册表单
                        VStack(spacing: 20) {
                            // 用户名输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("用户名")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                                
                                TextField("3-20字符，字母数字下划线", text: $username)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            // 设备 ID 输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("设备 ID")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                                
                                TextField("请输入设备 ID", text: $deviceId)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            // 邮箱输入框（可选）
                            VStack(alignment: .leading, spacing: 8) {
                                Text("邮箱（可选）")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                                
                                TextField("请输入邮箱", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                            }
                            
                            // 密码输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("密码")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                                
                                SecureField("至少6个字符", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // 确认密码输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("确认密码")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                                
                                SecureField("请再次输入密码", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // 注册按钮
                            Button(action: {
                                Task {
                                    await register()
                                }
                            }) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color(hex: Constants.UI.primaryColor))
                                        .cornerRadius(10)
                                } else {
                                    Text("注册")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color(hex: Constants.UI.primaryColor))
                                        .cornerRadius(10)
                                }
                            }
                            .disabled(!isFormValid || authViewModel.isLoading)
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("注册")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .alert("注册失败", isPresented: $showErrorAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .alert("注册成功", isPresented: $showSuccessAlert) {
                Button("确定") {
                    dismiss()
                }
            } message: {
                Text("账号创建成功，请登录")
            }
        }
    }
    
    // MARK: - 表单验证
    
    private var isFormValid: Bool {
        return !username.isEmpty &&
               !deviceId.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty &&
               password == confirmPassword &&
               authViewModel.validateUsername(username) &&
               authViewModel.validatePassword(password) &&
               (email.isEmpty || authViewModel.validateEmail(email))
    }
    
    // MARK: - 注册
    
    private func register() async {
        do {
            let emailToUse = email.isEmpty ? nil : email
            try await authViewModel.register(
                username: username,
                password: password,
                deviceId: deviceId,
                email: emailToUse
            )
            showSuccessAlert = true
        } catch {
            showErrorAlert = true
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}