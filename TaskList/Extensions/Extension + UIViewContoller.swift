//
//  Extension + UIViewContoller.swift
//  TaskList
//
//  Created by Alexey Efimov on 05.05.2025.
//

import UIKit

extension UIViewController {
    /**
     Добавляет `UIView` в указанный контейнер и применяет к нему автолэйаут-констрейнты.

     Этот метод автоматически добавляет переданный `UIView` в `container` (если он указан) или во `view` контроллера.
     Затем он настраивает констрейнты для привязки элемента к указанным `top`, `bottom`, `leading` и `trailing` отступам.
     При необходимости можно задать фиксированные размеры `width` и `height`, а также привязать `topAnchor` или `bottomAnchor` к другому элементу.

     - Parameters:
       - item: `UIView`, к которому будут применены констрейнты.
       - container: Опциональный контейнер (`UIView`), в который будет добавлен `item`. Если не указан, используется `view` контроллера.
       - relativeTo: Опциональный `UIView`, относительно которого будет установлен `topAnchor`. Если `nil`, `item` выравнивается по `safeAreaLayoutGuide.topAnchor`.
       - alignToTopOf: Опциональный `UIView`, относительно которого будет установлен `bottomAnchor`. Используется для привязки элемента к `topAnchor` другого элемента.
       - top: Опциональное значение `CGFloat`, определяющее отступ сверху.
       - leading: Опциональное значение `CGFloat`, определяющее отступ слева. Если `nil`, `leadingAnchor` не устанавливается (по умолчанию `0`).
       - trailing: Опциональное значение `CGFloat`, определяющее отступ справа. Если `nil`, `trailingAnchor` не устанавливается (по умолчанию `0`).
       - bottom: Опциональное значение `CGFloat`, определяющее отступ снизу.
       - width: Опциональное значение `CGFloat`, определяющее фиксированную ширину элемента.
       - height: Опциональное значение `CGFloat`, определяющее фиксированную высоту элемента.

     - Example:
     ```swift
     applyConstraints(to: myView, top: 20, leading: 16, trailing: 16, height: 50)
     applyConstraints(to: anotherView, relativeTo: myView, top: 10, leading: 16, trailing: 16)
     ```
     */
    func applyConstraints(
        to item: UIView,
        in container: UIView? = nil,
        relativeTo anchorItem: UIView? = nil,
        alignToTopOf anchorTopItem: UIView? = nil,
        top: CGFloat? = nil,
        leading: CGFloat? = 0,
        trailing: CGFloat? = 0,
        bottom: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        // Определяем родительский контейнер (по умолчанию - view контроллера)
        guard let parentView = container ?? view else { return }
        item.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(item)
        
        var constraints: [NSLayoutConstraint] = []


        // Верхний отступ: либо к `anchorItem`, либо к `safeAreaLayoutGuide` родительского контейнера
        if let top {
            let topAnchor = anchorItem?.bottomAnchor ?? parentView.safeAreaLayoutGuide.topAnchor
            constraints.append(item.topAnchor.constraint(equalTo: topAnchor, constant: top))
        }

        // Нижний отступ (если передан `anchorTopItem`, привязываем `bottomAnchor` к `topAnchor` этого элемента)
        if let anchorTopItem {
            constraints.append(item.bottomAnchor.constraint(equalTo: anchorTopItem.topAnchor, constant: -bottom!))
        } else if let bottom {
            constraints.append(item.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -bottom))
        }

        // Leading и Trailing (используем `layoutMarginsGuide`, если доступно)
        if let leading {
            constraints.append(item.leadingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.leadingAnchor, constant: leading))
        }
        if let trailing {
            constraints.append(item.trailingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.trailingAnchor, constant: -trailing))
        }

        // Фиксированные размеры
        if let width {
            constraints.append(item.widthAnchor.constraint(equalToConstant: width))
        }
        if let height {
            constraints.append(item.heightAnchor.constraint(equalToConstant: height))
        }

        NSLayoutConstraint.activate(constraints)
    }
    
// Делаем текст зачеркнутым
    func strikeText(strike: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        return attributeString
    }
}
