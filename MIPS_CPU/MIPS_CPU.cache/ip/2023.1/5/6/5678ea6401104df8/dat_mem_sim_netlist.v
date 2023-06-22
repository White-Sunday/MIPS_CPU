// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Wed Jun 21 16:32:39 2023
// Host        : LAPTOP-TSH2P4SS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dat_mem_sim_netlist.v
// Design      : dat_mem
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dat_mem,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.95215 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "dat_mem.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
aMT3usC6uizzcwnzOCX4OsS16Ob+YxFcsGovFpFklbnaIaD1S0lVdxenTwHPp6ByIEi+ehwr6Rgg
z/3AlTheI5NFTM8ihiMA18/wmUxI7EbaftJACA1LykUKCuj5myy0T+DACuv3sGYIZS38TZTZnnBC
FGAlvTZmRWs+JzneH3o=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lR9ZerhYSAb39nzEkeYvhnwEs5t9y/+yTDf8KuoUtR1BGeHZq8pA/YxtjzQLtaOW1R1IQUb0FtSI
e3CYAb7WHYbIjcpw3vKHvW1SqcGn9CMGa556CYKmD2oF12Kow8xRaFvMSBUVxX7HsHxNWnRd+PU1
+C0YayU2KFIY/7Yl6cZ5luAzhw/6SW3PFYUIyyqWy5MCIXweHOwQR2IpQEdlDur5nluN7i7BeB+i
fxwwHh8TU/g7T4mhZFkiTuBKdLAtQOjxWxzqTMxgcuAjlTylY16FgMFOASdvvSbqBZJjbxMdVloU
rYjS8O/8rWktv8GXcaIdBJ2BRj01q7jsChsbwA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Qvl63GHz9mq2xOB7elt/vAQ7URLGdD1Lkcz7f3Wtw31dwjjjbP62Ny/Jr6OmBIheWlgejx38qxAT
TrHiiEyjKmGcnPn1Tn2n+cH4RAxCbOFnCI9n6+YsYMTe9JkplGhGGr39SkFgJz0I2IKpPsuqTjCj
rhf49TAryNMQeRpREJA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MA+9Ro+dh339m0iZrkKbqTKN8gQ5xkxN/SPCfhkOn+5jjgCTS5IOKLHil+HsZDjX333ebxnornwG
MOBxyEdFfLM8SA+bs2r41J/j0af2VVMmCM3hOh8JmZxB4X9Jg/glegNCbvwzqxMbOQNEy+zt7j5t
TFVD82RtPFmYVVYZZyll/WvAA+0aVpyjzLCIM1GznFky0RWLv65Wp4MJJnNRRrtG3muMznVO/u2s
tACsJ9jzv9M0IlMYjYH9BixhG6cZX02I4LEXXaPkhdOINlMMhsbArXtc9NphzmS4bY1/1yF1D6YD
EKLyS2Sr3HDl0O/lefN+jvfG8iKuVl55PNNrVQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wpMTg7STjFkUDhOqdNPa0FHXTnHQgKmhvqDv+rRVBvMiQ8O7u8oj7ibITq3o+jugJsMJ60B410gQ
JFTcqCJKYmYJvqi8rPLLOYDmFG6ZLP/Ixr3n62IyIaCeDltBahi3yV009QN0X+iuzuFCL+Y7g9ff
IvAgyBly+Z3Itv2H9EJMZPMl17Sa7IkgjmWqzVXIKNMKn0iDVYsQw6ZgzQDYQ8N8IvTIEggU3/lh
6Nf0hV0ev3qOv/2P+4w0U766Ux3yLuzPJSI7bKm3/ip9NjhOytxOiKKqVXhKG8dzbbuS5u3EE/eq
q6YxkL7gpvNltVqqBnJB6vHSyWrD6+MqsCtR9A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q7Q4SSp70lxFryaopuic9VVP/Ire0pSsPEIMYdURBAczC7ShkuYeV02U7L3BlAiyBE4vBKcwYSQd
cWiaj8sVP7q4kxoRHKxLV1R5PIO6l4DsLWE2E+1MLyUPME0w5KTular/oX8EPCJ5n/8VCtW7x4Vf
dpeyki1/IAPJkAyi3zVZKHzgKhEwnZaZZtZYuMWoPZMt4V38sAcE42Raf+7yfFWG5HO74JY6iEnW
gJeRk58K+avB/XLF2/j2RQZfjTYizrprT2tUMBK6e7DRWZZtk8AOcsMhUikev44IFGNbNXjP8BXC
0J3y3P7pCFT6l+saU83nRwi/H25fSA34diJtNw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a/8ooC+s+6nfvfa1+oBhsvYWLJjFgp83DI1kNyOi5Am+ugPbGRmgGZudfyo6yw6Yd5gGbLm5aToQ
5G4cGF5HaXD5TU6A0ZZFMTIbzFLE76JMjjIxX8JcaJIZpSmrXqlru8l5gDINUEAmwUY3mRQnjcGJ
0Z+kMRH8iAEF+gEviPiFZSBbJeOPqivIS217kimQJX3BeNbNPQTP+GUidcRywpGMh5avxtA0kDRO
F9SoCSyTm9hr2v9hsK1IUAYQLb7n2/R+z5YNKNzt1oN4qgJH1wZfdI8if2K8+ohyOdnxrrgJOWdj
cOqr7cGqEOYfBMTIQeHVZzb7NGWVN+9B8XSUaQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
FLPvOUNRWNW2GU+FEGmt2XWthOT5bY/31DRbol2cUmEGNF6b2XzpCosNKGx/o2n6sQvGP39KRFCs
nJu0ihe2dUGee9nEZZUcpwPjnEfXVI3yJaRVYy8iL+rm59lXq0jX4sjAPieDvv8shgAnoXLTZGlq
K+2c1JhaHt+nFi27TDrYar/+P8nP1MhocOS7BjzCvSs0foEXj92/qD+71Sm/LqGr8cjlH2qTJJ8B
ynxoH6iT+bksVA2VbtPT9o6h1kJ/zwP4wcsL9l+qSlJhd4GI11JPux26DlNyIi41WmufQcfiT0PB
r6O9+0E9lV9ODwKdjaxfZRK29rjKeq2yr0jWhMV38XKKqHAJli7MIypGRXcCo+u89H87KgYt+ebw
s3foIqCe0JKR57WzI8VD6XdNtOL8eBxK539oemx4vkE0cGYECZKYru6A2hPeZOYDD5eyWSUlQl1R
EciK49WM8HnssyRVcmE6di6bISMbVi0TZG/v98bz+9UZa8DtqMVYH0tz

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fphquQOeFuqByo36Gh2C1zEC1J6u9swSMbMzsKldIvLm+SZ6/hr/N8KJ/G2vBABzX6UtbVuP1ZXx
AxdftP4Aqis1B3Bs6989aQG9eo0SOHA7r6aFLtFb3qoD5Pvqw4aVNU4z4EtTpFpn/jCWD21lKROf
q5X32HRfFq1jwqod+9vIbUNRRzz5y9VHvXfacZlxDazSPmcCF4hxB1KqWqT44KmYVkDedgkgnYgb
ZGidHnTb3W7C8tSqC9ac4kNJCL429QndtddweESJNlpX+65pt9Irok9pkOodwoj0QScswOIFjhBZ
/GrzZLQcFWiD3gXRU4DazzxQnGdRH4qEIRWziw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
1lUYYHPCt1BUJOvcBbgMU2GSQiqfxItz4ntieMaenjrtsE9SLwaU6xB0tBl8Atw5yP/RRNww1kX/
9uZbTz5He3r9mPVt+mGxB4N3f9BbCrQRb4USVPgKO/+vWUfMQERGklScy0+fz75WuxH74CjRUoDI
8iyssb2cUNnfDe13jIoI8gM1w4w/Pkxkmb6Mef53QMxacHAWEZeytcH3fuL/adO263D8P90U3XJv
vBXJmbjkRVi9qzjBzfMxuOy2KbZaZgR3BLzaffIfFnMwg/Rb8sGls5pQsZv5jL2wk3+Bj3OXBYdd
pDyjGoalJBzObKzd/t15kNHwY4FXYFcZLQPncw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YRmSEzaa2WFVvMH1BwWc1TIUpVbzSEIP0VbI6n0sEgct/X4PiTfMQmK1jBVCaISIzwBxscKQwZOt
mb/nmINGg6I7ih39LSbBMtx6cdCUiyaLkPeRbqfyPpKhvnUIFmdKVvTd1dYzxeOeuDnhSVaBaAcN
3lngSg7lIbmhLIGjC29yQrBTiLArbVZi6IRGronMK51e3UrYa6GspsznhiuRcXjEb4bHKrJ2CM5Z
BUwA+E9949sQgyOagFZbLVle2ESbwBaoxcAPn2gxfRHlT0leqyLgUGDZLsfArzGzw9BTGzyEG2TR
XOrKFNYRfMXMrnGsBM7acIelY4LdAMgsKgDH/A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27952)
`pragma protect data_block
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
OxJ1LEJLlCQrE8ge7nzGou6yR89f5w==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
