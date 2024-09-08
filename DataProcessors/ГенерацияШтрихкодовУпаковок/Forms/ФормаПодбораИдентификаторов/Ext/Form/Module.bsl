﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВыбранныеИдентификаторы") Тогда
		ВыбранныеИдентификаторы = Параметры.ВыбранныеИдентификаторы;
	Иначе
		ВыбранныеИдентификаторы = Новый Массив;
	КонецЕсли;
	
	СвойстваИдентификаторовПрименения = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
	
	Для каждого КлючИЗначение Из СвойстваИдентификаторовПрименения Цикл
		НоваяСтрока = Идентификаторы.Добавить();
		НоваяСтрока.КлючИдентификатора = КлючИЗначение.Ключ;
		НоваяСтрока.ИмяИдентификатора = КлючИЗначение.Значение.ИмяИдентификатора;
		НоваяСтрока.ПредставлениеИдентификатора = КлючИЗначение.Значение.ПредставлениеИдентификатора;
		
		Если НЕ ВыбранныеИдентификаторы.Найти(НоваяСтрока.КлючИдентификатора) = Неопределено Тогда
			НоваяСтрока.Пометка = Истина;
			НоваяСтрока.РанееВыбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Идентификаторы.Сортировать("КлючИдентификатора");
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИдентификаторы

&НаКлиенте
Процедура ИдентификаторыПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Идентификаторы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.КлючИдентификатора = "02" Тогда
		Для Каждого СтрокаТЧ Из Идентификаторы Цикл
			Если СтрокаТЧ.КлючИдентификатора = "01" И ТекущиеДанные.Пометка Тогда
				СтрокаТЧ.Пометка = Ложь;
			ИначеЕсли СтрокаТЧ.КлючИдентификатора = "37" Тогда
				СтрокаТЧ.Пометка = ТекущиеДанные.Пометка;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТекущиеДанные.КлючИдентификатора = "01" Тогда
		Для Каждого СтрокаТЧ Из Идентификаторы Цикл
			Если СтрокаТЧ.КлючИдентификатора = "02" И ТекущиеДанные.Пометка Тогда
				СтрокаТЧ.Пометка = Ложь;
			ИначеЕсли СтрокаТЧ.КлючИдентификатора = "37" И ТекущиеДанные.Пометка Тогда
				СтрокаТЧ.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТекущиеДанные.КлючИдентификатора = "37" Тогда
		Для Каждого СтрокаТЧ Из Идентификаторы Цикл
			Если СтрокаТЧ.КлючИдентификатора = "02" Тогда
				СтрокаТЧ.Пометка = ТекущиеДанные.Пометка;
			ИначеЕсли СтрокаТЧ.КлючИдентификатора = "01" И ТекущиеДанные.Пометка Тогда
				СтрокаТЧ.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	РезультатВыбора = РезультатВыбора();
	
	Если НЕ РезультатВыбора = Неопределено Тогда
		Оповестить("ПодборИдентификаторовПримененияGS1", РезультатВыбора, ВладелецФормы);
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатВыбора()
	
	Результат = Новый Структура("ДобавленныеСтроки, УдаленныеСтроки", Новый Массив, Новый Массив);
	
	ВыбранныеСтроки = Идентификаторы.НайтиСтроки(Новый Структура("Пометка, РанееВыбран", Истина, Ложь));
	Для каждого Строка Из ВыбранныеСтроки Цикл
		Результат.ДобавленныеСтроки.Добавить(Строка.КлючИдентификатора);
	КонецЦикла;
	
	ВыбранныеСтроки = Идентификаторы.НайтиСтроки(Новый Структура("Пометка, РанееВыбран", Ложь, Истина));
	Для каждого Строка Из ВыбранныеСтроки Цикл
		Результат.УдаленныеСтроки.Добавить(Строка.КлючИдентификатора);
	КонецЦикла;
	
	Если Результат.ДобавленныеСтроки.Количество() = 0
		И Результат.УдаленныеСтроки.Количество() = 0 Тогда
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти