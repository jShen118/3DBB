//
//  SwiftUIView.swift
//  3DBB
//
//  Created by Joshua Shen on 5/4/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import SwiftUI

struct SwiftUIView : UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        return UIStoryboard(name: "Main.storyboard", bundle: Bundle.main).instantiateInitialViewController()!.view
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#if DEBUG
struct SwiftUIView_Previews : PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
#endif
