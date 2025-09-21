import { ReceiveDebugNUI } from "$utils/eventsHandlers";
import type { DebugEventCallback } from "$types/events";

const ReceiveDebuggers: DebugEventCallback[] = [
    {
        action: "getEntities",
        handler: () => {
            return {
                result: [
                    // Cluster 1: Parking lot with cars (very close together)
                    { id: "1(net:5)", type: "vehicle", model: "adder", position: { x: 100.5, y: 200.2, z: 30.1, w: 1 }, script: null, isNetworked: true },
                    { id: "2(net:75)", type: "vehicle", model: "zentorno", position: { x: 102.1, y: 201.8, z: 30.1, w: 1 }, script: null, isNetworked: true },
                    { id: "3", type: "vehicle", model: "adder", position: { x: 104.3, y: 200.5, z: 30.1, w: 1 }, script: null, isNetworked: false },
                    { id: "4(net:88)", type: "vehicle", model: "infernus", position: { x: 101.7, y: 203.2, z: 30.1, w: 1 }, script: null, isNetworked: true },

                    // Cluster 2: Traffic cones stacked on each other (0 distance)
                    { id: "5", type: "object", model: "prop_roadcone02a", position: { x: 150.0, y: 150.0, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
                    { id: "6", type: "object", model: "prop_roadcone02a", position: { x: 150.0, y: 150.0, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
                    { id: "7", type: "object", model: "prop_roadcone02a", position: { x: 150.0, y: 150.0, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },
                    { id: "8", type: "object", model: "prop_roadcone02a", position: { x: 150.1, y: 150.1, z: 29.5, w: 1 }, script: "road_construction", isNetworked: false },

                    // Cluster 3: Gas station props
                    { id: "9(net:123)", type: "object", model: "prop_gas_pump_1d", position: { x: 300.2, y: 400.1, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
                    { id: "10(net:124)", type: "object", model: "prop_gas_pump_1d", position: { x: 303.5, y: 400.3, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
                    { id: "11(net:125)", type: "object", model: "prop_gas_pump_old2", position: { x: 301.8, y: 402.7, z: 31.2, w: 1 }, script: "gas_station", isNetworked: true },
                    { id: "12", type: "object", model: "prop_generator_03", position: { x: 299.1, y: 398.9, z: 31.2, w: 1 }, script: null, isNetworked: false },

                    // Cluster 4: Dumpster area (multiple same models close together)
                    { id: "13", type: "object", model: "prop_dumpster_02a", position: { x: 50.3, y: 75.7, z: 28.8, w: 1 }, script: null, isNetworked: false },
                    { id: "14", type: "object", model: "prop_dumpster_02a", position: { x: 52.1, y: 76.2, z: 28.8, w: 1 }, script: null, isNetworked: false },
                    { id: "15", type: "object", model: "prop_dumpster_02a", position: { x: 51.8, y: 78.9, z: 28.8, w: 1 }, script: null, isNetworked: false },
                    { id: "16", type: "object", model: "prop_bin_05a", position: { x: 49.7, y: 77.1, z: 28.8, w: 1 }, script: null, isNetworked: false },
                    { id: "17", type: "object", model: "prop_bin_05a", position: { x: 54.2, y: 75.3, z: 28.8, w: 1 }, script: null, isNetworked: false },

                    // Cluster 5: Street lights in a line
                    { id: "18(net:201)", type: "object", model: "prop_streetlight_01", position: { x: 500.0, y: 600.0, z: 32.0, w: 1 }, script: "street_lighting", isNetworked: true },
                    { id: "19(net:202)", type: "object", model: "prop_streetlight_01", position: { x: 504.5, y: 600.0, z: 32.0, w: 1 }, script: "street_lighting", isNetworked: true },
                    { id: "20(net:203)", type: "object", model: "prop_streetlight_01", position: { x: 509.0, y: 600.0, z: 32.0, w: 1 }, script: "street_lighting", isNetworked: true },
                    { id: "21(net:204)", type: "object", model: "prop_streetlight_01", position: { x: 513.5, y: 600.0, z: 32.0, w: 1 }, script: "street_lighting", isNetworked: true },

                    // Scattered individual items (should not group)
                    { id: "22", type: "object", model: "prop_bench_01a", position: { x: 1000.0, y: 1000.0, z: 35.0, w: 1 }, script: null, isNetworked: false },
                    { id: "23(net:301)", type: "object", model: "prop_tree_pine_01", position: { x: 2000.0, y: 2000.0, z: 40.0, w: 1 }, script: "landscaping", isNetworked: true },
                    { id: "24(net:302)", type: "object", model: "prop_atm_01", position: { x: 3000.0, y: 3000.0, z: 30.0, w: 1 }, script: "banking", isNetworked: true },

                    // Cluster 6: Construction site (mixed models, close together)
                    { id: "25", type: "object", model: "prop_barrier_work05", position: { x: 800.1, y: 850.2, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
                    { id: "26", type: "object", model: "prop_barrier_work05", position: { x: 801.7, y: 851.8, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
                    { id: "27", type: "object", model: "prop_barrier_work05", position: { x: 803.2, y: 849.6, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
                    { id: "28", type: "object", model: "prop_tool_box_04", position: { x: 799.8, y: 852.1, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
                    { id: "29", type: "object", model: "prop_tool_box_04", position: { x: 804.5, y: 851.3, z: 25.3, w: 1 }, script: "construction", isNetworked: false },
                    { id: "30(net:401)", type: "object", model: "prop_generator_01a", position: { x: 802.3, y: 853.7, z: 25.3, w: 1 }, script: "construction", isNetworked: true },

                    // Cluster 7: Beach props
                    { id: "31(net:501)", type: "object", model: "prop_beach_parasol_01", position: { x: 1200.5, y: 1300.7, z: 15.2, w: 1 }, script: "beach_setup", isNetworked: true },
                    { id: "32(net:502)", type: "object", model: "prop_beach_parasol_01", position: { x: 1205.2, y: 1302.1, z: 15.2, w: 1 }, script: "beach_setup", isNetworked: true },
                    { id: "33", type: "object", model: "prop_beach_chair_01", position: { x: 1201.8, y: 1299.4, z: 15.2, w: 1 }, script: null, isNetworked: false },
                    { id: "34", type: "object", model: "prop_beach_chair_01", position: { x: 1203.7, y: 1304.8, z: 15.2, w: 1 }, script: null, isNetworked: false },
                    { id: "35", type: "object", model: "prop_beach_chair_01", position: { x: 1207.1, y: 1300.9, z: 15.2, w: 1 }, script: null, isNetworked: false },

                    // Cluster 8: Pharmacy/shop area (very close, overlapping)
                    { id: "36", type: "object", model: "v_ret_ml_chips", position: { x: 650.0, y: 720.0, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
                    { id: "37", type: "object", model: "v_ret_ml_chips", position: { x: 650.02, y: 720.01, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
                    { id: "38", type: "object", model: "v_ret_ml_soda", position: { x: 650.1, y: 720.15, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },
                    { id: "39", type: "object", model: "v_ret_ml_soda", position: { x: 650.08, y: 720.12, z: 35.5, w: 1 }, script: "shop_interior", isNetworked: false },

                    // Cluster 9: Large cluster of same vehicles (spawn glitch simulation)
                    { id: "40(net:601)", type: "vehicle", model: "taxi", position: { x: 400.0, y: 500.0, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },
                    { id: "41(net:602)", type: "vehicle", model: "taxi", position: { x: 400.2, y: 500.1, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },
                    { id: "42(net:603)", type: "vehicle", model: "taxi", position: { x: 400.4, y: 500.2, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },
                    { id: "43(net:604)", type: "vehicle", model: "taxi", position: { x: 400.1, y: 499.8, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },
                    { id: "44(net:605)", type: "vehicle", model: "taxi", position: { x: 399.9, y: 500.3, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },
                    { id: "45(net:606)", type: "vehicle", model: "taxi", position: { x: 400.3, y: 499.9, z: 28.0, w: 1 }, script: "taxi_spawner", isNetworked: true },

                    // Cluster 10: Furniture cluster (interior glitch simulation)
                    { id: "46", type: "object", model: "v_res_tre_sofa", position: { x: 1500.2, y: 1600.3, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
                    { id: "47", type: "object", model: "v_res_tre_sofa", position: { x: 1501.1, y: 1600.8, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
                    { id: "48", type: "object", model: "v_res_tre_coffeetable", position: { x: 1500.7, y: 1601.2, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },
                    { id: "49", type: "object", model: "v_res_tre_coffeetable", position: { x: 1500.9, y: 1599.9, z: 45.1, w: 1 }, script: "interior_decorator", isNetworked: false },

                    // Some more isolated entities
                    { id: "50(net:701)", type: "object", model: "prop_flag_us", position: { x: 5000.0, y: 5000.0, z: 50.0, w: 1 }, script: "government", isNetworked: true },
                    { id: "51(net:702)", type: "object", model: "prop_windmill_01", position: { x: 6000.0, y: 6000.0, z: 100.0, w: 1 }, script: "renewable_energy", isNetworked: true },
                    { id: "52(net:703)", type: "object", model: "prop_water_tower_01", position: { x: 7000.0, y: 7000.0, z: 80.0, w: 1 }, script: "utilities", isNetworked: true },

                    // Edge case: Two clusters of same model far apart
                    { id: "53", type: "object", model: "prop_bskball_01", position: { x: 900.0, y: 950.0, z: 30.0, w: 1 }, script: null, isNetworked: false },
                    { id: "54", type: "object", model: "prop_bskball_01", position: { x: 902.0, y: 951.0, z: 30.0, w: 1 }, script: null, isNetworked: false },
                    { id: "55", type: "object", model: "prop_bskball_01", position: { x: 1800.0, y: 1850.0, z: 35.0, w: 1 }, script: null, isNetworked: false },
                    { id: "56", type: "object", model: "prop_bskball_01", position: { x: 1801.5, y: 1851.2, z: 35.0, w: 1 }, script: null, isNetworked: false },

                    // Very tight cluster (problematic spawning)
                    { id: "57(net:801)", type: "object", model: "prop_cash_trolly", position: { x: 250.0, y: 350.0, z: 40.0, w: 1 }, script: "bank_robbery", isNetworked: true },
                    { id: "58(net:802)", type: "object", model: "prop_cash_trolly", position: { x: 250.001, y: 350.001, z: 40.0, w: 1 }, script: "bank_robbery", isNetworked: true },
                    { id: "59(net:803)", type: "object", model: "prop_cash_trolly", position: { x: 250.002, y: 350.002, z: 40.0, w: 1 }, script: "bank_robbery", isNetworked: true },
                    { id: "60(net:804)", type: "object", model: "prop_security_case_01", position: { x: 250.003, y: 350.003, z: 40.0, w: 1 }, script: "bank_robbery", isNetworked: true },

                    { id: "61(net:805)", type: "object", model: "prop_bskball_01", position: { x: 250.0, y: 350.0, z: 40.0, w: 1 }, script: "basketball_event", isNetworked: true },
                    { id: "62(net:806)", type: "object", model: "prop_bskball_01", position: { x: 250.001, y: 350.001, z: 40.0, w: 1 }, script: "basketball_event", isNetworked: true },
                    { id: "63", type: "object", model: "prop_bskball_01", position: { x: 250.002, y: 350.002, z: 40.0, w: 1 }, script: null, isNetworked: false },
                    { id: "64", type: "object", model: "prop_bskball_01", position: { x: 250.003, y: 350.003, z: 40.0, w: 1 }, script: null, isNetworked: false },
                ],
            };
        },
    },
];

export default ReceiveDebuggers;

export function InitializeDebugReceivers(): void {
    for (const event of ReceiveDebuggers) {
        ReceiveDebugNUI(event.action, event.handler);
    }
}
