module Pipeline_tb();
    reg clk,rst;
    always #5 clk = ~clk;
    Pipeline_Top DUT(.clk(clk),.rst(rst));
    initial begin
        rst=1'b1;
        clk=1'b0;
        #300  $stop;
        end
endmodule
