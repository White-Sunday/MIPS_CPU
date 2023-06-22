// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Wed Jun 21 16:33:16 2023
// Host        : LAPTOP-TSH2P4SS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ins_mem_sim_netlist.v
// Design      : ins_mem
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ins_mem,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [31:0]douta;
  wire ena;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.622 mW" *) 
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
  (* C_INIT_FILE = "ins_mem.mem" *) 
  (* C_INIT_FILE_NAME = "ins_mem.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
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
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .wea(1'b0),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27408)
`pragma protect data_block
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
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
