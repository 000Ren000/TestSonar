﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения")
		И ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Обработка.СервисДоставки.Форма.СписокЗаказов"
		И ПараметрыВыполненияКоманды.Источник.ТипГрузоперевозки = СервисДоставкиКлиентСервер.ТипГрузоперевозкиСервис1СКурьерика() Тогда
		
		ТекущиеДанные = ПараметрыВыполненияКоманды.Источник.Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			
			ТрекНомер = ТекущиеДанные.ТрекНомер;
			Если ЗначениеЗаполнено(ТрекНомер) Тогда
				Оповещение = Новый ОписаниеОповещения();
				НачатьЗапускПриложения(Оповещение,СервисДоставкиКлиентСервер.АдресСтраницыЗаказаНаДоставку1СКурьерика(ТрекНомер),,Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Параметры = Новый Структура();
		Параметры.Вставить("ТипГрузоперевозки", 1);
		СервисДоставкиКлиент.ОткрытьФормуОтслеживанияЗаказа(Параметры);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
