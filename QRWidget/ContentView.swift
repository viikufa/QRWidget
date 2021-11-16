//
//  ContentView.swift
//  QRWidget
//
//  Created by Vitaliy on 15.11.2021.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String? = UserDefaultsService.code
    @State private var showingAlert = false

    let qrGenerator = QRGenerator()
 
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if let code = scannedCode {
                    Image(uiImage: qrGenerator.generate(from: code))
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: UIScreen.main.bounds.width / 1.1,
                            height: UIScreen.main.bounds.width / 1.1
                        )
                    Spacer(minLength: 4)
                    HStack(alignment: VerticalAlignment.center, spacing: 24) {
                        Button("Удалить") {
                            showingAlert = true
                        }.foregroundColor(Color.red)
                            .padding()
                            .background(Color(.systemGray4))
                            .clipShape(Capsule())
                        if let url = URL(string: code) {
                            Link("Открыть URL", destination: url)
                                .foregroundColor(Color(.label))
                                .padding()
                                .background(Color(.systemGray4))
                                .clipShape(Capsule())
                        }
                    }
                    Spacer(minLength: 12)
                } else {
                    Button("Отсканировать код") {
                        self.isPresentingScanner = true
                    }.padding()
                        .foregroundColor(Color.white)
                        .background(Color(.systemGray))
                        .clipShape(Capsule())
                    Divider()
                    Text("Отсканируйте код чтобы начать")
                }
                Divider()
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
                .alert("Вы уверенеы что хотите удалить код?", isPresented: $showingAlert) {
                    Button("Удалить", role: .destructive) {
                        UserDefaultsService.code = nil
                        scannedCode = nil
                    }
                    Button("Отменить", role: .cancel) {}
                }
            }

        }
    }

    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code
                    UserDefaultsService.code = code
                    self.isPresentingScanner = false
                }
            }
        )
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
