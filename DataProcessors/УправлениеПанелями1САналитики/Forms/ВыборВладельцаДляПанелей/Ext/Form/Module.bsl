﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВозможныеВладельцы = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	Для Каждого Владелец Из ВозможныеВладельцы Цикл
		НоваяСтрока = ТаблицаВладельцев.Добавить();
		НоваяСтрока.Владелец = Владелец;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаВладельцев

&НаКлиенте
Процедура ТаблицаВладельцевВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбранноеЗначение = Элементы.ТаблицаВладельцев.ТекущиеДанные.Владелец;
	Закрыть(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбранноеЗначение = Элементы.ТаблицаВладельцев.ТекущиеДанные.Владелец;
	Закрыть(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти