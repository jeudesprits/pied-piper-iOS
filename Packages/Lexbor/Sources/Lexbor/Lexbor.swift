// The Swift Programming Language
// https://docs.swift.org/swift-book

@_implementationOnly
import Darwin
@_implementationOnly
import CLexbor // 73673

public func test() {
    let html = "<div>Works fine!</div>"
    
    guard let document = lxb_html_document_create() else {
        preconditionFailure()
    }
    assert(html.withCString({ lxb_html_document_parse(document, $0, strlen($0)) }) == LXB_STATUS_OK.rawValue)
    
    guard let body = document.pointer(to: \.body)?.pointee,
          let tagName = body.withMemoryRebound(to: lxb_dom_element_t.self, capacity: 1, { lxb_dom_element_qualified_name($0, nil) })
    else {
        preconditionFailure()
    }
    
    print(String(cString: tagName))
    lxb_html_document_destroy(document)
}
