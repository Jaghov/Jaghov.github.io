use dioxus::prelude::*;

static CSS: Asset = asset!("/assets/main.css");

fn main() {
    dioxus::launch(App);
}

#[component]
fn App() -> Element {
    rsx! {
        document::Stylesheet { href: CSS }
        DogApp { breed: "corgi" }
    }
}

#[derive(Props, PartialEq, Clone)]
struct DogProps {
    breed: String,
}

#[component]
fn DogApp(props: DogProps) -> Element {
    rsx! {
        div { id: "title",
            h1 { "Joseph Aghoghovbia" },
        }
        div { id: "dogview",
            img { src: "https://media1.tenor.com/m/lZuEjo0EGW4AAAAd/snowman-mewing.gif" }
        }
        div { id: "buttons",
            button { id: "skip", "skip" },
            button { id: "save", "save!" }
        }
    }
}
