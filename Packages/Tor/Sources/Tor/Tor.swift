//
//  Tor.swift
//
//
//  Created by Ruslan Lutfullin on 01/12/22.
//

public enum Tor {
    
    public static func encode(_ message: String) -> String {
        String(message.lazy.map { LookupTable.shared[encode: $0] })
    }
    
    public static func decode(_ encryptedMessage: String) -> String {
        String(encryptedMessage.lazy.map { LookupTable.shared[decode: $0] })
    }
}

extension Tor {
    
    internal final class LookupTable {
        
        internal static let shared = LookupTable()
        
        private let forward: [Character: Character]
        
        private let backward: [Character: Character]
        
        internal subscript(encode character: Character) -> Character {
            forward[character, default: character]
        }
        
        internal subscript(decode character: Character) -> Character {
            backward[character, default: character]
        }
        
        private init() {
            (forward, backward) = withUnsafeTemporaryAllocation(of: Character.self, capacity: 54) { buffer in
                var index = 0
                for value in (Unicode.Scalar("A").value...Unicode.Scalar("Z").value) {
                    let character = Character(UnicodeScalar(value)!)
                    buffer.initializeElement(at: index, to: character)
                    index += 1
                }
                for value in (Unicode.Scalar("a").value...Unicode.Scalar("z").value) {
                    let character = Character(UnicodeScalar(value)!)
                    buffer.initializeElement(at: index, to: character)
                    index += 1
                }
                buffer.initializeElement(at: index, to: "_")
                index += 1
                buffer.initializeElement(at: index, to: ":")
                index += 1
                
                var forward = [Character: Character]()
                forward.reserveCapacity(buffer.count)
                var backward = [Character: Character]()
                backward.reserveCapacity(buffer.count)
                
                for index in buffer.indices {
                    let letter = buffer[index]
                    let mappedLetter = buffer[(index + 21) % buffer.count]
                    forward[letter] = mappedLetter
                    backward[mappedLetter] = letter
                }
                
                return (consume forward, consume backward)
            }
        }
    }
}
