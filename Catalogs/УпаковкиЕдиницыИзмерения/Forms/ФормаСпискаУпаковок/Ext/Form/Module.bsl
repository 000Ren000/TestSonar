﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда

		Владелец          = Параметры.Отбор.Владелец;
		ВладелецДляОтбора = Неопределено;
		ОбщиеУпаковки     = Неопределено;

		Если Владелец = Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения Тогда
			ТекстИсключения = НСтр("ru = 'Форма не предназначена для отображения списка единиц измерения.'");
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;	
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда

			ВладелецНаборУпаковок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "НаборУпаковок");

			Если ВладелецНаборУпаковок = Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеУпаковки = Ложь;
			Иначе
				ВладелецДляОтбора = ВладелецНаборУпаковок;
				
				Если ЗначениеЗаполнено(ВладелецДляОтбора) Тогда
					ОбщиеУпаковки = Истина;
				Иначе
					ВладелецДляОтбора = Неопределено;
				КонецЕсли;
				
			КонецЕсли;

		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.НаборыУпаковок") Тогда

			Если Владелец <> Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеУпаковки = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ВладелецДляОтбора = Неопределено Тогда

			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" использование упаковок не определено'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));

			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;

			Элементы.Список.ТолькоПросмотр = Истина;
			
		Иначе
			
			ТекстЗаголовка = НСтр("ru = 'Упаковки (%Владелец%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(ВладелецДляОтбора));

			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;
			
		КонецЕсли;
		
		Если ОбщиеУпаковки = Истина Тогда
			Элементы.ДекорацияПредупреждение.Видимость = Истина;
			Элементы.ДекорацияПредупреждение.Заголовок = Элементы.ДекорацияПредупреждение.Заголовок + " """ + Строка(ВладелецДляОтбора) + """";
		Иначе
			Элементы.ДекорацияПредупреждение.Видимость = Ложь;
		КонецЕсли;
			
		Параметры.Отбор.Владелец = ВладелецДляОтбора;
		
		Если ЗначениеЗаполнено(ВладелецДляОтбора) Тогда
			Элементы.Владелец.Видимость = Ложь;
		КонецЕсли;

	КонецЕсли;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_УпаковкиНоменклатурыСписок", Владелец);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

