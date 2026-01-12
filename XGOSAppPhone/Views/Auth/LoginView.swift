//
//  LoginView.swift
//  XGOSAppPhone
//
//  登录界面
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegisterView = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景色
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Logo 和标题
                    VStack(spacing: 16) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color(hex: Constants.UI.primaryColor))
                        
                        Text("XGOSAPP")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: Constants.UI.textColor))
                        
                        Text("车机哨兵系统")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                    .padding(.bottom, 40)
                    
                    // 登录表单
                    VStack(spacing: 20) {
                        // 用户名输入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("用户名")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                            
                            TextField("请输入用户名", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        // 密码输入框
                        VStack(alignment: .leading, spacing: 8) {
                            Text("密码")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                            
                            SecureField("请输入密码", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // 登录按钮
                        Button(action: {
                            Task {
                                await login()
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
                                Text("登录")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color(hex: Constants.UI.primaryColor))
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(username.isEmpty || password.isEmpty || authViewModel.isLoading)
                    }
                    .padding(.horizontal, 30)
                    
                    // 注册链接
                    Button(action: {
                        showRegisterView = true
                    }) {
                        Text("还没有账号？立即注册")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: Constants.UI.primaryColor))
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("登录")
            .navigationBarHidden(true)
            .alert("登录失败", isPresented: $showErrorAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .sheet(isPresented: $showRegisterView) {
                RegisterView()
                    .environmentObject(authViewModel)
            }
        }
    }
    
    // MARK: - 登录
    
    private func login() async {
        do {
            try await authViewModel.login(username: username, password: password)
        } catch {
            showErrorAlert = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}