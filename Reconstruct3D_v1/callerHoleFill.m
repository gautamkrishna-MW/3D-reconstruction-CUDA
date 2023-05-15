
clearMEX;

dStr = load('testDispInp.mat');
% imshow(dStr.dispMapGpu,[]);

outDisp = dStr.dispMapGpu;
% outDisp = holeFillGpuImpl(outDisp,40);

cdrConfig = coder.gpuConfig;
cdrConfig.GpuConfig.ComputeCapability = '7.5';
cdrConfig.GpuConfig.EnableMemoryManager = 1;
cdrArgs = {outDisp, coder.Constant(40)};
codegen -config cdrConfig holeFillGpuImpl -args cdrArgs -report -o gpuMEX

outDisp = gpuMEX(outDisp,40);
fh = @()gpuMEX(outDisp,40);
execTimeGpu = timeit(fh)*1000;

figure,imshow(outDisp,[]);colormap jet; colorbar;