#!/bin/bash
#
# generate_weapon_metas.sh
# Generates the boilerplate meta files (weaponarchetypes, weaponanimations) for a weapon
#
# Usage: ./generate_weapon_metas.sh WEAPON_NAME [auto]
#   WEAPON_NAME: The weapon name without WEAPON_ prefix (e.g., g17, g19x_switch)
#   auto: Optional - use full-auto pistol animations (for G18, switches)
#
# Example: ./generate_weapon_metas.sh g17
# Example: ./generate_weapon_metas.sh g19x_switch auto

if [ -z "$1" ]; then
    echo "Usage: $0 WEAPON_NAME [auto]"
    echo "Example: $0 g17"
    echo "Example: $0 g19x_switch auto"
    exit 1
fi

WEAPON_NAME=$1
WEAPON_HASH="WEAPON_${WEAPON_NAME^^}"
AUTO_MODE=$2

echo "Generating meta files for $WEAPON_HASH..."

# Create meta directory if it doesn't exist
mkdir -p meta

# Generate weaponarchetypes.meta (same for all weapons)
cat > meta/weaponarchetypes.meta << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponModelInfo__InitDataList>
  <InitDatas />
</CWeaponModelInfo__InitDataList>
EOF
echo "Created meta/weaponarchetypes.meta"

# Generate weaponanimations.meta
if [ "$AUTO_MODE" == "auto" ]; then
    # Full-auto pistol template
    MOTION_CLIP="weapons@pistol@ap_pistol"
    WEAPON_CLIP="weapons@pistol@ap_pistol"
    WEAPON_CLIP_STR="weapons@pistol@ap_pistol_str"
    FIRE_RATE_MOD="1.500000"
    BLIND_FIRE_MOD="1.500000"
    WANTING_SHOOT_MOD="4.000000"
    echo "Using FULL-AUTO pistol animations"
else
    # Semi-auto pistol template
    MOTION_CLIP="weapons@pistol@pistol"
    WEAPON_CLIP="weapons@pistol@pistol"
    WEAPON_CLIP_STR="weapons@pistol@pistol_str"
    FIRE_RATE_MOD="1.000000"
    BLIND_FIRE_MOD="1.000000"
    WANTING_SHOOT_MOD="3.000000"
    echo "Using SEMI-AUTO pistol animations"
fi

cat > meta/weaponanimations.meta << EOF
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponAnimationsSets>
  <WeaponAnimationsSets>
    <Item key="Default">
      <WeaponAnimations>
        <Item key="${WEAPON_HASH}">
          <CoverMovementClipSetHash />
          <CoverMovementExtraClipSetHash />
          <CoverAlternateMovementClipSetHash>cover@move@ai@base@1h</CoverAlternateMovementClipSetHash>
          <CoverWeaponClipSetHash>Cover_Wpn_Pistol</CoverWeaponClipSetHash>
          <MotionClipSetHash>${MOTION_CLIP}</MotionClipSetHash>
          <MotionFilterHash>BothArms_filter</MotionFilterHash>
          <MotionCrouchClipSetHash />
          <MotionStrafingClipSetHash />
          <MotionStrafingStealthClipSetHash />
          <MotionStrafingUpperBodyClipSetHash />
          <WeaponClipSetHash>${WEAPON_CLIP}</WeaponClipSetHash>
          <WeaponClipSetStreamedHash>${WEAPON_CLIP_STR}</WeaponClipSetStreamedHash>
          <WeaponClipSetHashInjured>weapons@pistol@pistol_injured</WeaponClipSetHashInjured>
          <WeaponClipSetHashStealth>weapons@pistol@pistol@stealth</WeaponClipSetHashStealth>
          <WeaponClipSetHashHiCover />
          <AlternativeClipSetWhenBlocked />
          <ScopeWeaponClipSet />
          <AlternateAimingStandingClipSetHash />
          <AlternateAimingCrouchingClipSetHash />
          <FiringVariationsStandingClipSetHash>combat_fire_variations_pistol</FiringVariationsStandingClipSetHash>
          <FiringVariationsCrouchingClipSetHash />
          <AimTurnStandingClipSetHash>combat_aim_turns_pistol</AimTurnStandingClipSetHash>
          <AimTurnCrouchingClipSetHash />
          <MeleeClipSetHash />
          <MeleeVariationClipSetHash />
          <MeleeTauntClipSetHash />
          <MeleeSupportTauntClipSetHash />
          <MeleeStealthClipSetHash />
          <ShellShockedClipSetHash>reaction@shellshock@unarmed</ShellShockedClipSetHash>
          <JumpUpperbodyClipSetHash />
          <FallUpperbodyClipSetHash />
          <FromStrafeTransitionUpperBodyClipSetHash>weapons@pistol@</FromStrafeTransitionUpperBodyClipSetHash>
          <SwapWeaponFilterHash>RightArm_NoSpine_filter</SwapWeaponFilterHash>
          <SwapWeaponInLowCoverFilterHash>RightArm_NoSpine_filter</SwapWeaponInLowCoverFilterHash>
          <AnimFireRateModifier value="${FIRE_RATE_MOD}" />
          <AnimBlindFireRateModifier value="${BLIND_FIRE_MOD}" />
          <AnimWantingToShootFireRateModifier value="${WANTING_SHOOT_MOD}" />
          <UseFromStrafeUpperBodyAimNetwork value="true" />
        </Item>
      </WeaponAnimations>
    </Item>
  </WeaponAnimationsSets>
</CWeaponAnimationsSets>
EOF
echo "Created meta/weaponanimations.meta"

echo ""
echo "Done! Meta files generated for ${WEAPON_HASH}"
echo ""
echo "Don't forget to update your fxmanifest.lua with these data_file declarations:"
echo ""
echo "data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'"
echo "data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'"
