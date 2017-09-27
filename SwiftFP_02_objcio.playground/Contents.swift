//: Playground - noun: a place where people can play

import Cocoa
import CoreImage

//测试数据
let url = URL(string: "http://ifanr-cdn.b0.upaiyun.com/wp-content/uploads/2017/08/Photo-28-11-2016-15-50-31-55.jpg")!
let image = CIImage(contentsOf: url)!

let radius = 5.0
let color = NSColor.red.withAlphaComponent(0.2)

//滤镜基本类型设计
typealias Filter = (CIImage) -> CIImage

//构建滤镜

//模糊
func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image]
        guard let filter = CIFilter(name: "CIGuassianBlur",
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage
    }
}

// 颜色叠层
func generate(color: NSColor) -> Filter {
    return { _ in
        let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage
    }
}

//合成滤镜
func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
                          kCIInputImageKey: overlay
        ]
        
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage.cropped(to: image.extent)
    }
}

// 组合颜色叠层滤镜
func overlay(color: NSColor) -> Filter {
    return { image in
        let overlay = generate(color: color)(image).cropped(to: image.extent)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

//let overlaidImage = overlay(color: color)(image)
//let blurredImage = blur(radius: radius)(image)

func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

//let blurAndOverLay = compose(filter: blur(radius: radius), with: overlay(color: color))
//let result1 = blurAndOverLay(image)

infix operator >>>

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

//let blurAndOverlay = blur(radius: radius) >>> overlay(color: color)
//let result2 = blurAndOverlay(image)


