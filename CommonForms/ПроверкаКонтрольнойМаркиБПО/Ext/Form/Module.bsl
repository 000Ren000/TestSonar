﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПараметрыПроверки = ОбщегоНазначенияБПОКлиент.ПараметрПриложения("БПО.ПроверкаКМ");
	ОбщегоНазначенияБПОКлиент.УдалитьПараметрПриложения("БПО.ПроверкаКМ");
	ПараметрыПодключения = ПараметрыПроверки.ПараметрыПодключения;
	ДанныеОперации       = ПараметрыПроверки.ДанныеОперации;
	
	Если ТипЗнч(ДанныеОперации.ЗапросыКМ) = Тип("Массив") Тогда
		МассивОпераций = ДанныеОперации.ЗапросыКМ;
	Иначе
		МассивОпераций = Новый Массив();
		МассивОпераций.Добавить(ДанныеОперации.ЗапросыКМ);
	КонецЕсли;
	
	Если МассивОпераций.Количество()=1 Тогда
		Отказ = Истина;
		Оповещение = ПараметрыПроверки.ОповещениеПриЗавершении;
	Иначе
		Оповещение = Новый ОписаниеОповещения("НачатьПроверкуКМЗавершение", ЭтотОбъект);
		ПодключитьОбработчикОжидания("Подключаемый_СтатусПроверкаКМ", 0.2, Истина);
	КонецЕсли;
	Элементы.ГруппаТекст.Видимость     = Ложь;
	Элементы.ГруппаСостояние.Видимость = Истина;
	Состояние = 0;
	МенеджерОборудованияМаркировкаКлиент.НачатьПроверкуКМ(Оповещение, ПараметрыПодключения, ДанныеОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПроверкуКМЗавершение(Результат, Контекст) Экспорт
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Результат = МенеджерОборудованияМаркировкаКлиент.СостояниеПроверкиКМ();
	Если Результат.ОбработкаЗавершена Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_СтатусПроверкаКМ()
	
	Результат = МенеджерОборудованияМаркировкаКлиент.СостояниеПроверкиКМ();
	Если Результат.ОбработкаЗавершена Тогда
		Состояние = 100;
		Возврат;
	КонецЕсли;
	
	Состояние = (Результат.ВыполненоОпераций+1) / Результат.ВсегоОпераций * 100;
	ПодключитьОбработчикОжидания("Подключаемый_СтатусПроверкаКМ", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти