//
//  GlideScene+ContactTestMap.swift
//  YAEngine
//

import Foundation

extension GlideScene {
    
    public func mapContact(between mask: CategoryMask, and otherMask: CategoryMask) {
        if let mapped = contactTestMap[mask.rawValue] {
            contactTestMap[mask.rawValue] = mapped | otherMask.rawValue
        } else {
            contactTestMap[mask.rawValue] = otherMask.rawValue
        }
    }
    
    public func canHaveContact(between mask: CategoryMask, and otherMask: CategoryMask) -> Bool {
        if let mapped = contactTestMap[mask.rawValue] {
            if mapped & otherMask.rawValue == otherMask.rawValue {
                return true
            }
        }
        
        if let mapped = contactTestMap[otherMask.rawValue] {
            if mapped & mask.rawValue == mask.rawValue {
                return true
            }
        }
        
        return false
    }
    
    public func unregisterContacts(for mask: CategoryMask) {
        contactTestMap[mask.rawValue] = nil
    }
    
    public func reset() {
        contactTestMap = [:]
    }
    
    // MARK: - Internal
    
    func notifyEnteredAndStayedContacts() {
        for contact in collisionsController.contacts {
            guard let state = collisionsController.stateForContact(contact) else {
                continue
            }
            
            notifyOriginalObjectForEnteredAndStayedContacts(contactContext: contact, state: state)
            notifyOtherObjectForEnteredAndStayedContacts(contactContext: contact, state: state)
        }
    }
    
    func notifyExitedContacts() {
        for contactContext in collisionsController.exitContacts {
            let contact = contactContext.contactForCollider
            for component in contact.collider.entity?.components ?? [] {
                if let colliderResponder = component as? YAComponent {
                    if contactContext.isCollision {
                        colliderResponder.handleFinishedCollision(contact)
                    } else {
                        colliderResponder.handleFinishedContact(contact)
                    }
                }
            }
            
            if let contactForOther = contactContext.contactForOtherObject {
                for component in contactForOther.collider.entity?.components ?? [] {
                    if let colliderResponder = component as? YAComponent {
                        if contactContext.isCollision {
                            colliderResponder.handleFinishedCollision(contactForOther)
                        } else {
                            colliderResponder.handleFinishedContact(contactForOther)
                        }
                    }
                }
            }
        }
    }
    
    private func notifyOriginalObjectForEnteredAndStayedContacts(contactContext: ContactContext,
                                                                 state: CollisionsController.ContactState) {
        let contact = contactContext.contactForCollider
        for component in contact.collider.entity?.components ?? [] {
            if let colliderResponder = component as? YAComponent {
                switch state {
                case .entered:
                    if contactContext.isCollision {
                        colliderResponder.handleNewCollision(contact)
                    } else {
                        colliderResponder.handleNewContact(contact)
                    }
                case .stayed:
                    if contactContext.isCollision {
                        colliderResponder.handleExistingCollision(contact)
                    } else {
                        colliderResponder.handleExistingContact(contact)
                    }
                }
            }
        }
    }
    
    private func notifyOtherObjectForEnteredAndStayedContacts(contactContext: ContactContext,
                                                              state: CollisionsController.ContactState) {
        guard let contactForOther = contactContext.contactForOtherObject else {
            return
        }
        
        for component in contactForOther.collider.entity?.components ?? [] {
            if let colliderResponder = component as? YAComponent {
                switch state {
                case .entered:
                    if contactContext.isCollision {
                        colliderResponder.handleNewCollision(contactForOther)
                    } else {
                        colliderResponder.handleNewContact(contactForOther)
                    }
                case .stayed:
                    if contactContext.isCollision {
                        colliderResponder.handleExistingCollision(contactForOther)
                    } else {
                        colliderResponder.handleExistingContact(contactForOther)
                    }
                }
            }
        }
    }
}
