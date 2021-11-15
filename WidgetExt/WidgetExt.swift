//
//  WidgetExt.swift
//  WidgetExt
//
//  Created by Vitaliy on 16.11.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let entry = SimpleEntry(date: UserDefaultsService.lastUpdate , configuration: configuration)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetExtEntryView : View {
    var entry: Provider.Entry
    @State var scannedCode: String? = UserDefaultsService.code
    let qrGenerator = QRGenerator()

    var body: some View {
        if let code = scannedCode {
            Image(uiImage: qrGenerator.generate(from: code))
                .resizable()
                .scaledToFit()
                .padding(
                    EdgeInsets(
                        top: 8,
                        leading: 8,
                        bottom: 8,
                        trailing: 8
                    )
                )
        } else {
            Text("Отсканировать QR код")
        }
    }
}

@main
struct WidgetExt: Widget {
    let kind: String = "WidgetExt"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetExtEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetExt_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
