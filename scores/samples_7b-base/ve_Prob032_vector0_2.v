
module TopModule(vec [2:0], outv [2:0], o0, o1, o2);
    assign outv[2:0] = vec[2:0];
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];
endmodule
