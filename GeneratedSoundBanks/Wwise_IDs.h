/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audiokinetic Wwise generated include file. Do not edit.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __WWISE_IDS_H__
#define __WWISE_IDS_H__

#include <AK/SoundEngine/Common/AkTypes.h>

namespace AK
{
    namespace EVENTS
    {
        static const AkUniqueID BOSS_KNIFE_ATTACKS = 2119463198U; //
        static const AkUniqueID DEFEATED = 2791675679U;
        static const AkUniqueID ENEMY_AGGRO = 352335356U;
        static const AkUniqueID ENEMY_DEATH = 1205999388U;
        static const AkUniqueID ENEMY_ITEM_THROWS = 2450329037U;
        static const AkUniqueID ENEMY_SAFE = 3717377857U;
        static const AkUniqueID ENEMYDAMAGE = 1879435608U;
        static const AkUniqueID ENTER_BOSS_ROOM = 3603472999U; //
        static const AkUniqueID ENTER_CASTLE = 2474813288U; 
        static const AkUniqueID ENTER_CATACOMBS = 2762024869U;
        static const AkUniqueID ENTER_TRIAL_ROOM = 1844506134U; //
        static const AkUniqueID FINAL_BOSS_PHASE2 = 1150116533U; //
        static const AkUniqueID FLOOR1 = 3162820674U;
        static const AkUniqueID FLOOR2 = 3162820673U;
        static const AkUniqueID FLOOR3 = 3162820672U;
        static const AkUniqueID FOOTSTEPS_01 = 2848855924U;
        static const AkUniqueID JOURNALPAGETURN = 1639161750U;
        static const AkUniqueID JUDGE_DIALOGUE_BY_FIRE = 2109575468U; //
        static const AkUniqueID JUDGE_DIALOGUE_SILENCE = 1862952859U; //
        static const AkUniqueID JURY_WHISPERS = 4151276193U; //
        static const AkUniqueID LASSO_ATTACH = 1402229995U; //
        static const AkUniqueID LASSO_WINDUP = 1461666693U; //
        static const AkUniqueID MAIN_MENU = 2005704188U;
        static const AkUniqueID MAP_LOAD = 780953876U;
        static const AkUniqueID MENU_BOOP = 3129090587U;
        static const AkUniqueID MENUOPEN = 48824776U;
        static const AkUniqueID PLAYER_TAKINGDAMAGE = 3625562942U;
        static const AkUniqueID QUEUE_CREDITS = 931351601U; //
        static const AkUniqueID RESPAWN = 4279841335U; 
        static const AkUniqueID SHACKLES_OFF = 3057807107U;
        static const AkUniqueID SHACKLES_ON = 3395044911U; //
        static const AkUniqueID SHOP_BUY = 1495252156U;
        static const AkUniqueID TAROTBURN = 2451853040U;
        static const AkUniqueID TAROTPICKUP = 1908595231U;
        static const AkUniqueID TEXT_SCROLLING = 371816340U; //
        static const AkUniqueID TRIAL_ROOM_FAILED = 2277544205U;
        static const AkUniqueID TRIAL_ROOM_GAVEL = 866175427U; //
        static const AkUniqueID VICTORY = 2716678721U; //
        static const AkUniqueID WAND_BASIC = 2783045536U; 
        static const AkUniqueID WAND_MISFIRE = 80501587U; //
        static const AkUniqueID WITCH0 = 3350869486U; //
        static const AkUniqueID WITCH1 = 3350869487U; //
        static const AkUniqueID WITCH2 = 3350869484U; //
        static const AkUniqueID WITCH3 = 3350869485U; //
        static const AkUniqueID WITCH_DIALOGUE = 2206927579U; //
    } // namespace EVENTS

    namespace STATES
    {
        namespace AMBIENCE_FLOOR
        {
            static const AkUniqueID GROUP = 2903394062U;

            namespace STATE
            {
                static const AkUniqueID FLOOR1 = 3162820674U;
                static const AkUniqueID FLOOR2 = 3162820673U;
                static const AkUniqueID FLOOR3 = 3162820672U;
                static const AkUniqueID NONE = 748895195U;
            } // namespace STATE
        } // namespace AMBIENCE_FLOOR

        namespace CATACOMB_WITCHES
        {
            static const AkUniqueID GROUP = 4243432011U;

            namespace STATE
            {
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID WITCH0 = 3350869486U;
                static const AkUniqueID WITCH1 = 3350869487U;
                static const AkUniqueID WITCH2 = 3350869484U;
                static const AkUniqueID WITCH3 = 3350869485U;
            } // namespace STATE
        } // namespace CATACOMB_WITCHES

        namespace LOCATION
        {
            static const AkUniqueID GROUP = 1176052424U;

            namespace STATE
            {
                static const AkUniqueID BOSS = 1560169506U;
                static const AkUniqueID CASTLE = 129146593U;
                static const AkUniqueID CATACOMBS = 2966204926U;
                static const AkUniqueID CREDITS = 2201105581U;
                static const AkUniqueID MAIN_MENU = 2005704188U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID TRIAL_ROOM = 1543475711U;
            } // namespace STATE
        } // namespace LOCATION

        namespace PLAYER_STATE
        {
            static const AkUniqueID GROUP = 4071417932U;

            namespace STATE
            {
                static const AkUniqueID ALIVE = 655265632U;
                static const AkUniqueID DEFEATED = 2791675679U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID VICTORY = 2716678721U;
            } // namespace STATE
        } // namespace PLAYER_STATE

    } // namespace STATES

    namespace SWITCHES
    {
        namespace FINAL_BOSS
        {
            static const AkUniqueID GROUP = 2345047989U;

            namespace SWITCH
            {
                static const AkUniqueID PHASE1 = 3630028971U;
                static const AkUniqueID PHASE2 = 3630028968U;
            } // namespace SWITCH
        } // namespace FINAL_BOSS

        namespace FLOOR_LEVEL
        {
            static const AkUniqueID GROUP = 3257587070U;

            namespace SWITCH
            {
                static const AkUniqueID FLOOR1 = 3162820674U;
                static const AkUniqueID FLOOR2 = 3162820673U;
                static const AkUniqueID FLOOR3 = 3162820672U;
            } // namespace SWITCH
        } // namespace FLOOR_LEVEL

        namespace GAMEPLAY_SWITCH
        {
            static const AkUniqueID GROUP = 2702523344U;

            namespace SWITCH
            {
                static const AkUniqueID COMBAT = 2764240573U;
                static const AkUniqueID EXPLORE = 579523862U;
            } // namespace SWITCH
        } // namespace GAMEPLAY_SWITCH

        namespace WANDSHOTS
        {
            static const AkUniqueID GROUP = 3734252994U;

            namespace SWITCH
            {
                static const AkUniqueID BASE = 1291433366U;
                static const AkUniqueID EMPOWERED = 542766697U;
            } // namespace SWITCH
        } // namespace WANDSHOTS

    } // namespace SWITCHES

    namespace GAME_PARAMETERS
    {
        static const AkUniqueID HEALTH = 3677180323U;
        static const AkUniqueID MUSIC_BACKUP_SIDECHAIN = 198116658U;
        static const AkUniqueID MUSIC_VOLUME_SLIDER = 2872980221U;
        static const AkUniqueID SFX_SIDECHAIN = 2862064063U;
        static const AkUniqueID SFX_VOLUME_SLIDER = 4274270069U;
    } // namespace GAME_PARAMETERS

    namespace BANKS
    {
        static const AkUniqueID INIT = 1355168291U;
        static const AkUniqueID MUSIC = 3991942870U;
        static const AkUniqueID SOUNDEFFECTS = 3898083304U;
    } // namespace BANKS

    namespace BUSSES
    {
        static const AkUniqueID AMBIENCE_MIXER = 1247349911U;
        static const AkUniqueID MASTER_AUDIO_BUS = 3803692087U;
        static const AkUniqueID MUSIC_MIXER = 2990548740U;
        static const AkUniqueID SFX_MIXER = 3131440204U;
    } // namespace BUSSES

    namespace AUDIO_DEVICES
    {
        static const AkUniqueID NO_OUTPUT = 2317455096U;
        static const AkUniqueID SYSTEM = 3859886410U;
    } // namespace AUDIO_DEVICES

}// namespace AK

#endif // __WWISE_IDS_H__
