//
//  DemoCategoryMask.swift
//  glide Demo
//


import YAEngine

enum DemoCategoryMask: UInt32, CategoryMask {
    case enemy = 0xa
    case npc = 0xb
    case projectile = 0xc
    case weapon = 0xd
    case hazard = 0xe
    case itemChest = 0xf
    case chestItem = 0x10
    case crate = 0x11
    case triggerZone = 0x12
    case collectible = 0x13
}

enum DemoLightMask: UInt32, LightMask {
    case torch = 0x1
}
