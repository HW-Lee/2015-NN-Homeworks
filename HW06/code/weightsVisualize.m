function [] = weightsVisualize( weights, r, c )

    if r*c < size(weights, 2)
        rndIdx = randperm(size(weights, 2));
        weights = weights(:, rndIdx);
    end
    dataSize = sqrt(size(weights, 1))*[1 1];
    for ii = 1:r*c
        if ii > size(weights, 2) continue; end
        subplot(r, c, ii);
        imagesc( reshape(weights(:, ii), dataSize) );
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        colormap(gray(256));
        axis square;
        drawnow;
    end

end

