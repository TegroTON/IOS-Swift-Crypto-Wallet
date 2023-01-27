import SwiftUI

struct MainChartView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                
            } label: {
                Text("Load Image")
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.blue)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
    }
}

struct MainChartView_Previews: PreviewProvider {
    static var previews: some View {
        MainChartView()
    }
}
