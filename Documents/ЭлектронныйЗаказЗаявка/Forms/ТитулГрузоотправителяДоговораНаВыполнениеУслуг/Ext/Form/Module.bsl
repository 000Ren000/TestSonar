﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтметитьОбязательныеНеЗаполненныеЭлементыФормы" Тогда
		Если УникальныйИдентификатор <> Параметр Тогда
			Возврат;
		КонецЕсли;
		ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр);
	ИначеЕсли ИмяСобытия = "ИзменитьОформлениеКнопокФормы" Тогда
		Если УникальныйИдентификатор <> Параметр.УникальныйИдентификаторОбновляемойФормы Тогда
			Возврат;
		КонецЕсли;
		ИзменитьОформлениеКнопок(Параметр);	 
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

&НаКлиенте
Процедура ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслугПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеСторонаПодписавшаяДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслуг.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеСторонаПодписавшаяДокументОткрытие(Элемент, СтандартнаяОбработка)

	Если ТипЗнч(Элементы.ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслуг.ТекущиеДанные.ХранимыеДанныеСторонаПодписавшаяДокумент) <> Тип("СправочникСсылка.ХранимыеДанныеЭПД") Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслуг.ТекущиеДанные, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеСторонаПодписавшаяДокументПриИзменении(Элемент)
	
	ЗначениеРеквизита = Элементы.ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслуг.ТекущиеДанные.ХранимыеДанныеСторонаПодписавшаяДокумент;
	ГруппаДанных = СтрЗаменить(Элемент.Имя, "ХранимыеДанные", "");
	Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		ВходящийКонтекст = Новый Структура;
		ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
		ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
		ВходящийКонтекст.Вставить("ГруппаДанных", ГруппаДанных);
		ВходящийКонтекст.Вставить("ТекущиеДанные", Элементы.ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслуг.ТекущиеДанные);
		ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(ЗначениеРеквизита, ВходящийКонтекст);	
	Иначе
		ОбменСГИСЭПДКлиентСервер.УдалитьРеквизитыПоГруппеДанных(ЭтотОбъект, ГруппаДанных);
		ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеЭлементовФормы(ЭтотОбъект, ГруппаДанных);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеСторонаПодписавшаяДокументАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ГруппаДанных = СтрЗаменить(Элемент.Имя, "ХранимыеДанные", "");
	ПараметрыПолученияДанных.Отбор = ОбменСГИСЭПДКлиент.ПолучитьОтборХранимыхДанных(ЭтотОбъект, ЭтотОбъект, ГруппаДанных);
	ПараметрыПолученияДанных.СпособПоискаСтроки = ПредопределенноеЗначение("СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяСтороныДоговораНаВыполнениеУслугПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры

#Область ОбъектыОбязательныеДляЗаполнения

&НаКлиенте
Процедура ИзменитьОформлениеКнопок(Параметр) Экспорт

	Если Не ЭтотОбъект.НачальноеОформлениеВыполнено Тогда
		ЭтотОбъект.ТребуетсяДополнительноеОформлениеКнопок = Истина;
		Если ЭтотОбъект.СтруктураДополнительногоОформленияКнопок <> Неопределено Тогда
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = 
				Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки");
		Иначе
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = Параметр;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	СтруктураДанныхОбъекта = ОбменСГИСЭПДКлиентСервер.ПолучитьСериализуемыйОбъектСДаннымиДокумента(ЭтотОбъект);
	СтруктураСДаннымиФормыДляОформленияКнопок = 
		ОбменСГИСЭПДКлиентСервер.СтруктураСДаннымиФормыДляОформленияКнопок(ЭтотОбъект);
	
	Результат = ИзменитьОформлениеКнопокНаСервере(СтруктураСТекущимиДаннымиРеквизитов,
		Параметр.ИмяКнопки,
		Параметр.ИдентификаторСтроки,
		СтруктураДанныхОбъекта,
		СтруктураСДаннымиФормыДляОформленияКнопок);
		
	Если Результат.Успешно Тогда
		ЭтотОбъект.АдресДереваСоответствийИтаблицыКнопок = Результат.НовыйАдресВХранилище;	
		МассивОформления = Результат.МассивОформления;
		ОбменСГИСЭПДКлиентСервер.ОформлениеКнопокНаФорме(ЭтотОбъект,
			СтруктураСТекущимиДаннымиРеквизитов, МассивОформления);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьОформлениеКнопокНаСервере(Знач СтруктураСТекущимиДаннымиРеквизитов,
	ИмяКнопки = Неопределено,
	ИдентификаторСтроки = Неопределено,
	Знач СтруктураДанныхОбъекта,
	Знач СтруктураСДаннымиФормыДляОформленияКнопок)
	
	НовыйАдресВХранилище = ОбменСГИСЭПД.ЗапуститьИзменениеОформленияКнопок(СтруктураСДаннымиФормыДляОформленияКнопок,
		СтруктураСТекущимиДаннымиРеквизитов, ИмяКнопки, ИдентификаторСтроки, СтруктураДанныхОбъекта);

	Результат = ОбменСГИСЭПД.ОбработатьРезультатИзмененияОформленияКнопок(НовыйАдресВХранилище);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр)
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(СтруктураСТекущимиДаннымиРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(Знач СтруктураСТекущимиДанными)
	
	ОбменСГИСЭПД.ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(ЭтотОбъект, СтруктураСТекущимиДанными);
	
КонецПроцедуры

#КонецОбласти