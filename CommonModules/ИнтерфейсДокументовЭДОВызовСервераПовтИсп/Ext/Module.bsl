﻿#Область СлужебныйПрограммныйИнтерфейс

// Данные области просмотра.
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО, 
//  ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ЭлектронныйДокумент.
//  ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  КонтрольОтраженияВУчете - Число
// 
// Возвращаемое значение:
//  Структура - Данные области просмотра:
// * ПредставлениеДокумента - ТабличныйДокумент
// * Распознан - Булево
// * Внутренний - Булево
// * ФайлСсылка - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// * ФайлПредставление - Строка
// * ФайлНомерИконки - Число
// * СообщениеЭДО - ДокументСсылка.СообщениеЭДО
//                - Неопределено
Функция ДанныеОбластиПросмотра(ЭлектронныйДокумент, КонтрольОтраженияВУчете) Экспорт

	СтруктураВозврат = Новый Структура;
   	СтруктураВозврат.Вставить("ПредставлениеДокумента", Новый ТабличныйДокумент);
	СтруктураВозврат.Вставить("Распознан", Ложь);
	СтруктураВозврат.Вставить("Внутренний", Ложь);
	СтруктураВозврат.Вставить("ФайлСсылка", Неопределено);   
	СтруктураВозврат.Вставить("ФайлПредставление", "");
	СтруктураВозврат.Вставить("ФайлНомерИконки", 0);
	СтруктураВозврат.Вставить("СообщениеЭДО", Неопределено);
	
	СтруктураВозврат.ПредставлениеДокумента = Неопределено;
	
	ДокументУчетаПредставление = Неопределено;
	СформироватьПредставлениеДокументаУчета(ЭлектронныйДокумент, ДокументУчетаПредставление,
		КонтрольОтраженияВУчете);
	 
	ЭтоВходящийЭДО = (ТипЗнч(ЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО"));
	
	ДанныеЭлектронногоДокумента = ИнтерфейсДокументовЭДО.ДанныеФормыПросмотраЭлектронногоДокумента(
		ЭлектронныйДокумент, ЭтоВходящийЭДО);
	
	Если ДанныеЭлектронногоДокумента.ДанныеЭлементовСхемы.Количество() = 0 Тогда
		Возврат СтруктураВозврат;
	КонецЕсли;
	
	ЭлементСхемыРегламента = Новый Структура;
	ЭлементСхемыРегламента.Вставить("АдресОписанияСообщения", "");
	ЭлементСхемыРегламента.Вставить("ВидДокумента", Неопределено);
	ЭлементСхемыРегламента.Вставить("ВидСообщения", Неопределено); 
	ЭлементСхемыРегламента.Вставить("ДатаИзмененияСтатуса", Неопределено);
	ЭлементСхемыРегламента.Вставить("ДополнительнаяИнформация", Неопределено); 
	ЭлементСхемыРегламента.Вставить("Доступность", Ложь); 
	ЭлементСхемыРегламента.Вставить("Наименование", ""); 
	ЭлементСхемыРегламента.Вставить("Направление", Неопределено);
	ЭлементСхемыРегламента.Вставить("ПрисоединенныйФайл", Неопределено); 
	ЭлементСхемыРегламента.Вставить("Сообщение", Неопределено);
	ЭлементСхемыРегламента.Вставить("СообщениеОтвета", Неопределено); 
	ЭлементСхемыРегламента.Вставить("Статус", Неопределено); 
	ЭлементСхемыРегламента.Вставить("ТипДокумента", Неопределено); 
	ЭлементСхемыРегламента.Вставить("ТипЭлементаРегламента", Неопределено);  
	ЭлементСхемыРегламента.Вставить("ПредставлениеСформировано", Ложь); 
	ЭлементСхемыРегламента.Вставить("ИмяРеквизита", "");
	ЭлементСхемыРегламента.Вставить("Распознан", Ложь); 
	ЭлементСхемыРегламента.Вставить("ИмяФайла", "");
	
	ИнформацияОтправителя = ДанныеЭлектронногоДокумента.ДанныеЭлементовСхемы.Найти(
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя, "ТипЭлементаРегламента");
	
	Если ИнформацияОтправителя <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭлементСхемыРегламента, ИнформацияОтправителя);
		
		ИнформацияПолучателя = ДанныеЭлектронногоДокумента.ДанныеЭлементовСхемы.Найти(
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя, "ТипЭлементаРегламента");
			
		Если ИнформацияПолучателя <> Неопределено Тогда
			ЭлементСхемыРегламента.СообщениеОтвета = ИнформацияПолучателя.Сообщение;
		КонецЕсли;

	Иначе
		ЗаполнитьЗначенияСвойств(ЭлементСхемыРегламента, ДанныеЭлектронногоДокумента.ДанныеЭлементовСхемы[0]);
	КонецЕсли;
	
	ДвоичныеДанныеФайла = Неопределено;
	Если ЗначениеЗаполнено(ЭлементСхемыРегламента.ПрисоединенныйФайл) Тогда
		ДвоичныеДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(ЭлементСхемыРегламента.ПрисоединенныйФайл);
	КонецЕсли;
		
	ДокументРаспознан = РаспознатьДокумент(ЭлектронныйДокумент); 
	СтруктураВозврат.Распознан = ДокументРаспознан;
		
	Если Не ДокументРаспознан
		И ЭлементСхемыРегламента.Направление <> Перечисления.НаправленияЭДО.Внутренний
		И ЭлементСхемыРегламента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.Прикладной Тогда
		
		СтруктураВозврат.ФайлСсылка = ЭлементСхемыРегламента.ПрисоединенныйФайл;
		
		ПараметрыДанныхФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыДанныхФайла.ИдентификаторФормы = Новый УникальныйИдентификатор;
		ПараметрыДанныхФайла.ПолучатьСсылкуНаДвоичныеДанные = Ложь;
		
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементСхемыРегламента.ПрисоединенныйФайл, ПараметрыДанныхФайла);
		
		СтруктураВозврат.ФайлПредставление = ДанныеФайла.ИмяФайла;
		Расширение = ДанныеФайла.Расширение;
		СтруктураВозврат.ФайлНомерИконки = ИнтеграцияБСПБЭД.ИндексПиктограммыФайла(Расширение);
		СтруктураВозврат.СообщениеЭДО = ЭлементСхемыРегламента.Сообщение;
				
	Иначе
						
		СформироватьТабличныйДокумент(СтруктураВозврат, ЭлементСхемыРегламента, ДокументУчетаПредставление,
			ДвоичныеДанныеФайла);
	
	КонецЕсли;
	Если СтруктураВозврат.ПредставлениеДокумента = Неопределено
		И Не ЗначениеЗаполнено(СтруктураВозврат.ФайлПредставление) Тогда
		СтруктураВозврат.ФайлСсылка = ЭлементСхемыРегламента.ПрисоединенныйФайл;
		
		ПараметрыДанныхФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыДанныхФайла.ИдентификаторФормы = Новый УникальныйИдентификатор;
		ПараметрыДанныхФайла.ПолучатьСсылкуНаДвоичныеДанные = Ложь;
		
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементСхемыРегламента.ПрисоединенныйФайл, ПараметрыДанныхФайла);
		
		СтруктураВозврат.ФайлПредставление = ДанныеФайла.ИмяФайла;
		Расширение = ДанныеФайла.Расширение;
		СтруктураВозврат.ФайлНомерИконки = ИнтеграцияБСПБЭД.ИндексПиктограммыФайла(Расширение);
		СтруктураВозврат.СообщениеЭДО = ЭлементСхемыРегламента.Сообщение;
	КонецЕсли;
	Возврат СтруктураВозврат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьПредставлениеДокументаУчета(Знач ЭлектронныйДокумент, ДокументУчетаПредставление,
		Знач КонтрольОтраженияВУчете)

	Основания = ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(ЭлектронныйДокумент);
	Если ЗначениеЗаполнено(Основания) Тогда
		
		КоличествоОснований = Основания.Количество();
		Если КоличествоОснований = 1 Тогда
			
			ШаблонСтроки = НСтр("ru = 'Открыть документ учета: %1'");
			ДокументУчетаПредставление = СтрШаблон(ШаблонСтроки, Основания[0].ОбъектУчета);
		
		Иначе
			
			ДокументУчетаПредставление = СтрШаблон(НСтр("ru = 'Открыть документы учета: %1'"), КоличествоОснований);
			ШаблонСтроки = НСтр("ru = ';%1 документ;;%1 документа;%1 документов;%1 документов'");
			ДокументУчетаПредставление = СтрокаСЧислом(ШаблонСтроки, КоличествоОснований, ВидЧисловогоЗначения.Количественное);
			ДокументУчетаПредставление = СтрШаблон(НСтр("ru = 'Открыть документы учета: %1'"), ДокументУчетаПредставление);
		
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО") Тогда
		
		Если КонтрольОтраженияВУчете = 0 Тогда
			
			ДокументУчетаПредставление = НСтр("ru = 'Сопоставить номенклатуру'");
		
		ИначеЕсли КонтрольОтраженияВУчете = 1 Тогда
			
			Если ТипЗнч(ЭлектронныйДокумент) = Перечисления.ТипыДокументовЭДО.КонтрактЕИС Тогда
				ДокументУчетаПредставление = НСтр("ru = 'Создать контракт'");
			Иначе
				ДокументУчетаПредставление = НСтр("ru = 'Создать документы учета'");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Сформировать табличный документ.
// 
// Параметры:
//  СтруктураВозврат - Структура - Структура возврат:
// * ПредставлениеДокумента - ТабличныйДокумент
// * Распознан - Булево
// * Внутренний - Булево
// * ФайлСсылка - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// * ФайлПредставление - Строка
// * ФайлНомерИконки - Число
//  ЭлементСхемыРегламента - Структура - Элемент схемы регламента:
// * АдресОписанияСообщения - Строка
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
// * ВидСообщения - СправочникСсылка.ВидыДокументовЭДО
// * ДатаИзмененияСтатуса - Дата
// * ДополнительнаяИнформация - Неопределено
// * Доступность - Булево
// * Наименование - Строка
// * Направление - ПеречислениеСсылка.НаправленияЭДО
// * ПрисоединенныйФайл - СправочникСсылка.СообщениеЭДОПрисоединенныеФайлы
// * Сообщение - ДокументСсылка.СообщениеЭДО
// * Статус - ПеречислениеСсылка.СтатусыСообщенийЭДО
// * ТипДокумента - ПеречислениеСсылка.ТипыДокументовЭДО
// * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыДокументовЭДО
// * ПредставлениеСформировано - Булево
// * ИмяРеквизита - Строка
// * Распознан - Булево
// * ИмяФайла - Строка
//  ДокументУчетаПредставление - Строка - Документ учета представление
//  ДвоичныеДанныеФайла - Произвольный, ДвоичныеДанные, Неопределено - Двоичные данные файла
Процедура СформироватьТабличныйДокумент(СтруктураВозврат, ЭлементСхемыРегламента, ДокументУчетаПредставление,
		ДвоичныеДанныеФайла)

	ПараметрыВизуализацииДокумента = ИнтерфейсДокументовЭДО.НовыеПараметрыВизуализацииДокумента();
	ПараметрыВизуализацииДокумента.ВыводитьБанковскиеРеквизиты =
	ЭлементСхемыРегламента.ТипДокумента = Перечисления.ТипыДокументовЭДО.СчетНаОплату;
	ПараметрыВизуализацииДокумента.ВыводитьДопДанные = Ложь;
	ПараметрыВизуализацииДокумента.ВыводитьКопияВерна = Ложь;
		
	Если ЭлементСхемыРегламента.ТипДокумента = Перечисления.ТипыДокументовЭДО.Внутренний Тогда
		
		ПредставлениеДокумента = ЭлектронныеДокументыЭДО.ПредставлениеДанныхВнутреннегоСообщения(
			ДвоичныеДанныеФайла).ПредставлениеДокумента;
		СтруктураВозврат.Внутренний = Истина;	
	
	ИначеЕсли ЭлементСхемыРегламента.ТипДокумента = Перечисления.ТипыДокументовЭДО.АктСверкиВзаиморасчетов
		Или ФорматыЭДО_ФНС.ЭтоПространствоИменАктСверкиВзаиморасчетов(ЭлементСхемыРегламента.ИмяФайла) Тогда
			
		ПараметрыПредставления = ЭлектронныеДокументыЭДО.НовыеПараметрыПолученияПредставленияДанныхСообщенияПоСсылке();
		ПараметрыПредставления.Сообщение = ЭлементСхемыРегламента.Сообщение;
		
		ПредставлениеДокумента = ЭлектронныеДокументыЭДО.ПредставлениеДанныхСообщенияПоСсылке(
			ПараметрыПредставления).ПредставлениеДокумента;
	Иначе
		
		СообщениеОтвета = Неопределено;	
		ЭлементСхемыРегламента.Свойство("СообщениеОтвета", СообщениеОтвета);
		
		ПараметрыПредставления = ЭлектронныеДокументыЭДО.НовыеПараметрыПолученияПредставленияДанныхСообщенияПоСсылке();
		ПараметрыПредставления.Сообщение = ЭлементСхемыРегламента.Сообщение;
		ПараметрыПредставления.СообщениеОтвета = СообщениеОтвета;
		ПараметрыПредставления.ПараметрыВизуализации = ПараметрыВизуализацииДокумента;
		
		ПредставлениеДокумента = ЭлектронныеДокументыЭДО.ПредставлениеДанныхСообщенияПоСсылке(
			ПараметрыПредставления).ПредставлениеДокумента;
	КонецЕсли;
	
	Если ПредставлениеДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронныеДокументыЭДО.ДополнитьТабличныйДокументШтампамиПодписей(
		ПредставлениеДокумента, ЭлементСхемыРегламента.Сообщение);
		
	ДополнитьТабличныйДокументСсылкойНаДокументУчета(ПредставлениеДокумента, ДокументУчетаПредставление);
	
	Если ПредставлениеДокумента.ВысотаТаблицы <> 0
		И ЭлементСхемыРегламента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.Прикладной
		И ЭлементСхемыРегламента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.Внутренний Тогда
			
		Если ЭлементСхемыРегламента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.СчетНаОплату
			И ЭлементСхемыРегламента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.КаталогТоваров Тогда
			УдаляемаяОбласть = ПредставлениеДокумента.Область("R1:R2");
		Иначе
			УдаляемаяОбласть = ПредставлениеДокумента.Область("R1:R1");				
		КонецЕсли;
		
		ПредставлениеДокумента.УдалитьОбласть(УдаляемаяОбласть, ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	КонецЕсли;
		
	ПредставлениеДокумента.Область("R1:R" + ПредставлениеДокумента.ВысотаТаблицы).ЦветРамки = 
			Метаданные.ЭлементыСтиля.ЦветРамкиПредпросмотраЭлектронногоДокумента.Значение;
	
	СтруктураВозврат.ПредставлениеДокумента = ПредставлениеДокумента;
	
КонецПроцедуры

// Выводит в табличный документ гиперссылку на документ учета
// 
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - документ в который будет добавлен вывод области представления
//  ДокументУчетаПредставление - Строка - текстовое представление документа учета
Процедура ДополнитьТабличныйДокументСсылкойНаДокументУчета(ТабличныйДокумент, ДокументУчетаПредставление)
	
	ШтампОбъектаУчета = Новый ТабличныйДокумент;
	
	МакетПредставлениеДокументаУчета = Обработки.ИнтерфейсДокументовЭДО.ПолучитьМакет("ПредставлениеОбъектаУчета_ru"); 
	ОбластьШапка = МакетПредставлениеДокументаУчета.ПолучитьОбласть("ДокументУчетаСтрока");
	ОбластьШапка.Параметры.ДокументУчетаПредставление = ДокументУчетаПредставление;
	ОбластьШапка.Область().СоздатьФорматСтрок();
	
	ОбщегоНазначенияБЭД.ВывестиОбластьВТабличныйДокумент(ШтампОбъектаУчета, ОбластьШапка, "ДокументУчетаСтрока");
	ОбщегоНазначенияБЭД.ВывестиОбластьВТабличныйДокумент(ТабличныйДокумент, ШтампОбъектаУчета, "ШтампОбъектаУчета");
	
КонецПроцедуры

Функция РаспознатьДокумент(ЭлектронныйДокумент)
	
	Если ЭлектронныйДокумент.ВидДокумента.ТипДокумента = Перечисления.ТипыДокументовЭДО.ДоговорныйДокумент Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Ложь;
	
	СообщениеОтправителя = ЭлектронныеДокументыЭДО.СообщениеОтправителя(ЭлектронныйДокумент);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС")
		И ЭлектронныйДокумент.СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезСерверЕИС Тогда
		МодульЭлектронноеАктированиеЕИС = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеАктированиеЕИС");
		РезультатРаспознавания =
		МодульЭлектронноеАктированиеЕИС.РаспознатьСообщение(СообщениеОтправителя);
		Результат = ЗначениеЗаполнено(РезультатРаспознавания);
	Иначе 
		Попытка
			Результат = ЗначениеЗаполнено(ЭлектронныеДокументыЭДО.РаспознатьСообщение(СообщениеОтправителя));
		Исключение
			Результат = Ложь;	
		КонецПопытки;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
#КонецОбласти
