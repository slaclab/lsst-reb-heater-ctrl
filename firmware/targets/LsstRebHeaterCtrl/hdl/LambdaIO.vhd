-------------------------------------------------------------------------------
-- Title      : Lambda Power Supply IO
-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- This file is part of LSST. It is subject to
-- the license terms in the LICENSE.txt file found in the top-level directory
-- of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of LSST, including this file, may be
-- copied, modified, propagated, or distributed except according to the terms
-- contained in the LICENSE.txt file.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

entity LambdaIO is
   generic (
      TPD_G : time := 1 ns);
   port (
      -- AXI-Lite Bus
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      cryoEn : in sl;
      coldplateEn : in sl;
      lambdaEnabled   : in  slv(5 downto 0);
      lambdaAcOk      : in  slv(5 downto 0);
      lambdaPwrOk     : in  slv(5 downto 0);
      lambdaOtw       : in  slv(5 downto 0);
      lambdaRemoteOnL : out slv(5 downto 0));
end entity LambdaIO;

architecture rtl of LambdaIO is

   type RegType is record
      lambdaRemoteOn : slv(5 downto 0);
      axilReadSlave  : AxiLiteReadSlaveType;
      axilWriteSlave : AxiLiteWriteSlaveType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      lambdaRemoteOn => (others => '0'),
      axilReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axilWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   comb : process (axilReadMaster, axilRst, axilWriteMaster, coldplateEn, cryoEn, lambdaAcOk, lambdaEnabled, lambdaOtw, lambdaPwrOk, r) is
      variable v  : RegType;
      variable ep : AxiLiteEndPointType;
   begin
      -- Latch the current value
      v := r;

      -- Determine the transaction type
      axiSlaveWaitTxn(ep, axilWriteMaster, axilReadMaster, v.axilWriteSlave, v.axilReadSlave);

      for i in 0 to 5 loop
         axiSlaveRegister(ep, toSlv(i*4, 8), 0, v.lambdaRemoteOn(i));
         axiSlaveRegisterR(ep, toSlv(i*4, 8), 1, lambdaEnabled(i));
         axiSlaveRegisterR(ep, toSlv(i*4, 8), 2, lambdaAcOk(i));
         axiSlaveRegisterR(ep, toSlv(i*4, 8), 3, lambdaPwrOk(i));
         axiSlaveRegisterR(ep, toSlv(i*4, 8), 4, lambdaOtw(i));
      end loop;

      -- Closeout the transaction
      axiSlaveDefault(ep, v.axilWriteSlave, v.axilReadSlave, AXI_RESP_DECERR_C);

      if (cryoEn = '0' or coldplateEn = '0') then
         v.lambdaRemoteOn(0) := '0';
      end if;

      -- Synchronous Reset
      if (axilRst = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs
      axilReadSlave   <= r.axilReadSlave;
      axilWriteSlave  <= r.axilWriteSlave;
      lambdaRemoteOnL <= not r.lambdaRemoteOn;
   end process;

   seq : process (axilClk) is
   begin
      if (rising_edge(axilClk)) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end architecture rtl;
